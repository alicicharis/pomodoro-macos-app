//
//  NotificationModel.swift
//  Pomodoro
//
//  Created by Haris Alicic on 21. 1. 2025..
//

import UserNotifications

struct NotificationService {
    private func authorize() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNotification() {
        authorize()
        
        let content = UNMutableNotificationContent()
        content.title = "Session done!"
        content.subtitle = "Take a break."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
