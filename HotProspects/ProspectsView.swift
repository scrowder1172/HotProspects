//
//  ProspectsView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import SwiftUI
import SwiftData
import CodeScanner

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    
    @State private var isShowingAddProspect: Bool = false
    @State private var isShowingScanner: Bool = false
    @State private var isShowingSelectedProspect: Bool = false
    
    @State private var userSelection: Prospect?
    @State private var listSelection: String?
    
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
            List(selection: $userSelection) {
                ForEach(prospects) { prospect in
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
                    .swipeActions(edge: .leading) {
                        Button("Contacted", systemImage: prospect.isContacted ? "questionmark.diamond" : "checkmark.circle"){
                            prospect.isContacted.toggle()
                        }
                        .tint(prospect.isContacted ? .blue : .green)
                        
                        Button("Edit Prospect", systemImage: "pencil.and.list.clipboard") {
                            userSelection = prospect
                            isShowingSelectedProspect = true
                        }
                        .tint(.orange)
                    }
                }
                .onDelete(perform: deleteProspect)
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
            }
            .sheet(isPresented: $isShowingAddProspect) {
                AddProspect()
            }
            .sheet(isPresented: $isShowingScanner) {
                QRScannerView()
            }
            .sheet(isPresented: $isShowingSelectedProspect) {
                if let userSelection {
                    SelectedProspectView(prospect: userSelection)
                }
                
            }
        }
    }
    
    func deleteProspect(at offsets: IndexSet) {
        for offset in offsets {
            let prospect = prospects[offset]
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
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
