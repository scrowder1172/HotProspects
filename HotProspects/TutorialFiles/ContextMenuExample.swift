//
//  ContextMenuExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/1/24.
//

import SwiftUI

struct ContextMenuExample: View {
    
    @State private var backgroundColor: Color = .red
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color(backgroundColor))
        
        Text("Change background color")
            .padding()
            .contextMenu {
                Button("Red", image: .hotPropsects1024, role: .destructive) {
                    backgroundColor = .red
                }
                
                Button("Blue", systemImage: "globe") {
                    backgroundColor = .blue
                }
                
                Button("Green", image: .example) {
                    backgroundColor = .green
                }
            }
    }
}

#Preview {
    ContextMenuExample()
}
