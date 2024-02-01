//
//  ControlImageInterpolationExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/1/24.
//

import SwiftUI

struct ControlImageInterpolationExample: View {
    
    @State private var interpolation: Bool = false
    
    var body: some View {
        Toggle("Turn on Interpolation", isOn: $interpolation)
            .padding()
        Image(.example)
            .interpolation(interpolation ? .high : .none)
            .resizable()
            .scaledToFit()
            .padding()
            .background(.black)
    }
}

#Preview {
    ControlImageInterpolationExample()
}
