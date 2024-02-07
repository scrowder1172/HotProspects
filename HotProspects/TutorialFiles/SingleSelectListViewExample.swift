//
//  SingleSelectListViewExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/1/24.
//

import SwiftUI

struct SingleSelectListViewExample: View {
    
    let users: [String] = ["Simon", "Peggy", "Wendy"]
    
    @State private var userSelection: String?
    
    var body: some View {
        NavigationStack {
            List(selection: $userSelection) {
                ForEach(users, id: \.self) {user in
                    Text(user)
                }
            }
            .navigationTitle("Users")
        }
        
        
        if let userSelection {
            Text("You have selected: ") +
            Text("\(userSelection)")
                .font(.title)
        }
    }
}

#Preview {
    SingleSelectListViewExample()
}
