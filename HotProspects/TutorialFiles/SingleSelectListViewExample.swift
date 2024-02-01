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
        List(users, id: \.self, selection: $userSelection) { user in
            Text(user)
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
