//
//  AppDelegate.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
//import FirebaseMessaging
import GoogleMobileAds
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
//      Messaging.messaging().delegate = self
      
      // Register for remote notifications
//      if #available(iOS 10.0, *) {
//          UNUserNotificationCenter.current().delegate = self
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
//      } else {
//          let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//      }
      
//      Messaging.messaging().token { token, error in
//        if let error = error {
//          print("Error fetching FCM registration token: \(error)")
////            application.registerForRemoteNotifications()
//        } else if let token = token {
//          print("FCM registration token: \(token)")
////          self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//        }
//      }
//      
//      application.registerForRemoteNotifications()
      
        realmMigration()
        return true
    }
    
    private func realmMigration() {
        RealmMigrationManager.shared.performMigration()
    }
}

// MARK: - MessagingDelegate
//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        guard let token = fcmToken else { return }
//        print("Firebase registration token: \(token)")
//        let dataDict: [String: String] = ["token": token]
//        NotificationCenter.default.post(
//            name: Notification.Name("FCMToken"),
//            object: nil,
//            userInfo: dataDict
//        )
//        // Store FCM token to send notifications to this device
//        // Implement your logic here to handle FCM token
//    }
//}

// MARK: - UNUserNotificationCenterDelegate
//@available(iOS 10, *)
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
//    }
//}
