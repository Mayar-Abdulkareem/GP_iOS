//
//  NotificationManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 11/01/2024.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notifications are authorized.")
            case .denied:
                print("Notifications are denied.")
            case .notDetermined:
                print("Notification permission has not been asked yet.")
            case .provisional:
                print("The application is authorized to post non-interruptive user notifications.")
            case .ephemeral:
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Unknown notification authorization status.")
            }
        }
    }

    func showNotification(fromID: String, details: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Request"
        content.body = "From: \(fromID), Details: \(details)"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error.localizedDescription)")
                return
            }
            print("Notification scheduled")
        }
    }


//    func showNotification(fromID: String, details: String) {
//
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.requestAuthorization { granted, error in
//            if let error = error {
//                // Handle errors
//            }
//
//            guard granted else { return }
//
//            let content = UNMutableNotificationContent()
//            content.title = "New Peer Request"
//            content.body = "You have a new peer request from \(fromID): \(details)"
//            content.sound = UNNotificationSound.default
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("Error showing notification: \(error.localizedDescription)")
//                    return
//                }
//            }
//        }
//
//    }


}
