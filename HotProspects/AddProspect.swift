//
//  AddProspect.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import SwiftUI
import SwiftData

struct AddProspect: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var emailAddress: String = ""
    @State private var isContacted: Bool = false
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                TextField("Name", text: $name)
                    .textContentType(.name)
                Text("Required")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            
            
            VStack(alignment: .leading) {
                TextField("Email", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                Text("Required")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            
            
            Toggle("Contacted", isOn: $isContacted)
            Button("Save Prospect") {
                if name.isEmpty == false && emailAddress.isEmpty == false {
                    let prospect: Prospect = Prospect(name: name, emailAddress: emailAddress, isContacted: isContacted)
                    modelContext.insert(prospect)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddProspect()
        .modelContainer(for: Prospect.self)
}
