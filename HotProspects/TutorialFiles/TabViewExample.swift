//
//  TabViewExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/1/24.
//

import SwiftUI

struct TabViewExample: View {
    
    @State private var selectedTab: String = "One"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .tabItem {
                    Label("One", systemImage: "star")
                }
                .tag("One")
            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
                .tag("Two")
            Button("Go To Tab One") {
                selectedTab = "One"
            }
            .tabItem {
                Label("Three", systemImage: "house")
            }
            .tag("Three")
        }
    }
}

#Preview {
    TabViewExample()
}
