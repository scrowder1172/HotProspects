//
//  SwiftPackageDependenciesExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import SwiftUI
import SamplePackage

struct SwiftPackageDependenciesExample: View {
    
    let possibleNumbers: Array<Int> = Array(1...60)
    
    var result: String {
        let selected: [Int] = possibleNumbers.random(7).sorted()
        let strings: [String] = selected.map(String.init)
        for string in strings {
            print(string)
        }
        return strings.formatted()
    }
    
    var body: some View {
        Text(result)
    }
}

#Preview {
    SwiftPackageDependenciesExample()
}
