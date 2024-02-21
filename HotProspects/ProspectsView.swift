//
//  ProspectsView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    
    @State private var isShowingAddProspect: Bool = false
    @State private var isShowingScanner: Bool = false
    
    @State private var selectedProspects: Set<Prospect> = Set<Prospect>()
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted People"
        case .uncontacted:
            "Uncontacted People"
        }
    }
    
    init(filter: FilterType) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly: Bool = filter == .contacted
            
            _prospects = Query(filter: #Predicate{
                $0.isContacted == showContactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }
    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                NavigationLink{
                    EditProspectView(prospect: prospect)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            
                            Text(prospect.emailAddress)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(prospect.isContacted ? .green : .blue)
                    }
                }
                .tag(prospect)
                .swipeActions(edge: .leading) {
                    Button("Contacted", systemImage: prospect.isContacted ? "questionmark.diamond" : "checkmark.circle"){
                        prospect.isContacted.toggle()
                    }
                    .tint(prospect.isContacted ? .blue : .green)
                    
                    if prospect.isContacted == false {
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect, repeatNotification: true, testNotification: false)
                        }
                        .tint(.yellow)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Prospect", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        isShowingAddProspect = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingAddProspect) {
                AddProspect()
            }
            .sheet(isPresented: $isShowingScanner) {
                QRScannerView()
            }
            .onAppear {
                selectedProspects = []
            }
        }
    }
    
    func deleteProspect(at offsets: IndexSet) {
        for offset in offsets {
            let prospect = prospects[offset]
            modelContext.delete(prospect)
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person: Prospect = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
        case .failure(let error):
            print("Scanning error: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect, repeatNotification: Bool = true, testNotification: Bool = false) {
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        
        let addRequest = {
            let content: UNMutableNotificationContent = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            if testNotification {
                let trigger: UNTimeIntervalNotificationTrigger
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: repeatNotification)
                let request: UNNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            } else {
                var dateComponents: DateComponents = DateComponents()
                dateComponents.hour = 16
                let trigger: UNCalendarNotificationTrigger
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeatNotification)
                let request: UNNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
        
        center.getNotificationSettings { settings in
            print("Alerts Setting: \(settings.alertSetting)")
            print("Badge Setting: \(settings.badgeSetting)")
            print("Sound Setting: \(settings.soundSetting)")
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
