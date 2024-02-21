//
//  Prosepct.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import Foundation
import SwiftData

@Model
final class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var dateAdded: Date = Date.now
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
    
    #if DEBUG
    static let example: Prospect = Prospect(name: "Sample", emailAddress: "sample@email.com", isContacted: false)
    #endif
}
