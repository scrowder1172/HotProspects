//
//  ListVIewExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/6/24.
//

import SwiftUI
import SwiftData

struct ListVIewExample: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    
    @State private var isShowingAddProspect: Bool = false
    @State private var isShowingScanner: Bool = false
    @State private var isShowingSelectedProspect: Bool = false    
    
    @State private var userSelection: Prospect?
    
    let people: [String] = ["Adam", "Eve", "Zelda"]
    @State private var name: String?
    
    var body: some View {
        NavigationStack {
            List(selection: $userSelection) {
                Text(userSelection?.name ?? "N/A")
                ForEach(prospects, id: \.self) { prospect in
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
                    }
                    .onTapGesture {
                        userSelection = prospect
                    }
                }
                .onDelete(perform: deleteProspect)
            }
            .sheet(isPresented: $isShowingSelectedProspect) {
                if let userSelection {
                    SelectedProspectView(prospect: userSelection)
                } else {
                    SelectedProspectView(prospect: Prospect.example)
                }
            }
            .navigationTitle("Prospects")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Prospect", systemImage: "qrcode.viewfinder") {
//                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
//                        isShowingAddProspect = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            
            List(selection: $name) {
                Text(name ?? "N/A")
                ForEach(people, id: \.self) {person in
                    Text(person)
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
}

#Preview {
    ListVIewExample()
        .modelContainer(for: Prospect.self)
}
