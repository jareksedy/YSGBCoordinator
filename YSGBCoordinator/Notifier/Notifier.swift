//
//  Notifier.swift
//  YSGBCoordinator
//
//  Created by Ярослав on 13.04.2022.
//

import UserNotifications

class Notifier {
    let center = UNUserNotificationCenter.current()
    
    func requestAuthorization(options: UNAuthorizationOptions) {
        center.requestAuthorization(options: options) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeNotificationContent(title: String, subtitle: String, body: String, badge: NSNumber?) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        
        return content
    }
    
    func makeIntervalNotificatioTrigger(timeInterval: Double, repeats: Bool) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
    }
    
    func notify(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        
        let request = UNNotificationRequest(identifier: "alaram", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
