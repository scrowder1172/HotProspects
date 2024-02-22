//
//  SortableProspectsView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/21/24.
//

import SwiftData
import SwiftUI

struct SortableProspectsView: View {
    
    let filter: ProspectsView.FilterType
    @State private var sortOrder = [SortDescriptor(\Prospect.name)]
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ProspectsView(filter: filter, sort: sortOrder, searchText: searchText)
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort") {
                            Picker("Sort Order", selection: $sortOrder) {
                                Text("Date Added")
                                    .tag([SortDescriptor(\Prospect.dateAdded),
                                          SortDescriptor(\Prospect.name)
                                         ])
                                Text("Name")
                                    .tag([SortDescriptor(\Prospect.name),
                                          SortDescriptor(\Prospect.dateAdded)])
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    SortableProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
