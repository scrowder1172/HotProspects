//
//  SelectedProspectView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/6/24.
//

import SwiftUI
import SwiftData

struct SelectedProspectView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State var prospect: Prospect
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $prospect.name)
                    .textContentType(.name)
                TextField("Email", text: $prospect.emailAddress)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                Toggle("Contacted", isOn: $prospect.isContacted)
            }
            .navigationTitle("Rename Prospect")
        }
        
    }
}

#Preview {
    do {
        let config: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container: ModelContainer = try ModelContainer(for: Prospect.self, configurations: config)
        let prospect: Prospect = Prospect(name: "Sample", emailAddress: "sample@email.com", isContacted: false)
        return SelectedProspectView(prospect: prospect)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
