//
//  LocalNotificationExample.swift
//  HotProspects
//
//  Created by SCOTT CROWDER on 2/5/24.
//

import SwiftUI
import UserNotifications

struct LocalNotificationExample: View {
    var body: some View {
        Button("Request Permission") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Permission received! All set")
                } else if let error {
                    print("Push Error: \(error.localizedDescription)")
                } else {
                    print("Something else happened with Push Notifications")
                }
            }
        }
        .buttonStyle(.borderedProminent)
        
        Button("Schedule Notification") {
            let content: UNMutableNotificationContent = UNMutableNotificationContent()
            content.title = "Feed the cat"
            content.subtitle = "It looks hungry"
            content.sound = UNNotificationSound.default
            
            let trigger: UNTimeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request: UNNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
            
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    LocalNotificationExample()
}
