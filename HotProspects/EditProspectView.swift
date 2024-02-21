//
//  EditProspectView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/21/24.
//

import SwiftData
import SwiftUI

struct EditProspectView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var prospect: Prospect
    
    var body: some View {
        Form {
            TextField("Name", text: $prospect.name)
            TextField("Email Address", text: $prospect.emailAddress)
            Toggle("Contacted", isOn: $prospect.isContacted)
        }
        .navigationTitle("Edit Prospect")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        
        let config: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container: ModelContainer = try ModelContainer(for: Prospect.self, configurations: config)
        let prospect: Prospect = Prospect(name: "Sample", emailAddress: "sample@email.com", isContacted: false)
        return EditProspectView(prospect: prospect)
            .modelContainer(container)
    } catch {
        return Text("unable to load model container")
    }
    
}
