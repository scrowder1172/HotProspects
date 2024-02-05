//
//  CustomRowSwipeActionExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import SwiftUI

struct CustomRowSwipeActionExample: View {
    
    @State private var showingAlert: Bool = false
    @State private var newItem: String = ""
    @State private var people: [String] = ["Taylor Swift"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(people, id: \.self) { person in
                    Text(person)
                        .swipeActions {
                            
                            Button("Delete", systemImage: "minus.circle", role: .destructive) {
                                print("Delete")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            
                            Button("Pin", systemImage: "pin") {
                                print("pinning")
                            }
                            .tint(.orange)
                            
                            Button("Send Message", systemImage: "message") {
                                print("Hello")
                            }
                            .tint(.green)
                        }
                }
                
            }
            .navigationTitle("Names")
            .toolbar {
                Button("Add row", systemImage: "plus") {
                    showingAlert = true
                }
            }
            .alert("Add Person", isPresented: $showingAlert) {
                TextField("New Person", text: $newItem)
                    .textContentType(.name)
                Button("OK") {
                    if newItem.isEmpty == false {
                        people.append(newItem)
                        newItem = ""
                    }
                }
                Button("Cancel") {}
            }
        }
    }
}

#Preview {
    CustomRowSwipeActionExample()
}
