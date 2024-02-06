//
//  MeView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @AppStorage("name") private var name: String = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress: String = "you@yoursite.com"
    
    let context: CIContext = CIContext()
    let filter: CIQRCodeGenerator = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("Email", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .font(.title)
                
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .navigationTitle("Your QR Code")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    MeView()
}
