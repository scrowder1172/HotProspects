//
//  QRScannerView.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/6/24.
//

import SwiftUI
import CodeScanner
import SwiftData

struct QRScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                CodeScannerView(codeTypes: [.qr, .pdf417, .ean8, .ean13, .upce], showViewfinder: true, completion: handleScan)
            }
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person: Prospect = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            dismiss()
        case .failure(let error):
            print("Scanning error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    QRScannerView()
}
