//
//  ResultTypeExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/1/24.
//

import SwiftUI

struct ResultTypeExample: View {
    
    @State private var output: String = ""
    
    var body: some View {
        Text(output)
            .task {
                await taskFetchReadings()
            }
    }
    
    func taskFetchReadings() async {
        let fetchTask: Task = Task {
            let url: URL = URL(string: "https://www.hackingwithswift.com/samples/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }
        
        let result: Result = await fetchTask.result
        
        do {
            output = try result.get()
        } catch {
            output = "Error: \(error.localizedDescription)"
        }
        
        switch result {
        case .success(let str):
            output = str
        case .failure(let error):
            output = "Error: \(error.localizedDescription)"
        }
    }
    
    func fetchReadings() async {
        do {
            let url: URL = URL(string: "https://www.hackingwithswift.com/samples/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            printJSONForDebugging(data: data)
            
            let readings = try JSONDecoder().decode([Double].self, from: data)
            output = "Found \(readings.count) readings"
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func printJSONForDebugging(data: Data, encoding: String.Encoding = .utf8) {
        if let string: String = String(data: data, encoding: encoding) {
            print("JSON String: \(string)")
        }
    }
}
#Preview {
    ResultTypeExample()
}
