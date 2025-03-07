//
//  LocalNotificationHelper.swift
//  YDY
//
//  Created by David Spurlock on 11/21/22.
//  Copyright © 2022 GST.PID. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationHelper {
    static func requestPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Granted")
            } else {
                print("Not Granted")
            }
        }
    }
    
    static func fireHeartRate(_ heartRate: Double) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Current heart rate"
        content.body = "Heart Reate = \(heartRate)"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}
