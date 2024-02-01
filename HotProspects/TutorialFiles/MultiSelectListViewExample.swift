//
//  MultiSelectListViewExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/1/24.
//

import SwiftUI

struct MultiSelectListViewExample: View {
    
    @State private var users: [String] = ["Tohru", "Yuki", "Kyo", "Momiji"]
    @State private var selection: Set<String> = Set<String>()
    
    var body: some View {
        NavigationStack {
            List(selection: $selection) {
                ForEach(users, id: \.self) { user in
                    NavigationLink(user) {
                        Text("You have selected: ") +
                        Text("\(user)")
                            .font(.headline)
                    }
                }
                .onDelete(perform: deleteUser)
            }
            .navigationTitle("Users")
            .toolbar {
                EditButton()
            }
            
            if selection.isEmpty == false {
                Text("You have selected \(selection.formatted())")
            }
            
        }
        
    }
    
    func deleteUser(offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
}

#Preview {
    MultiSelectListViewExample()
}
