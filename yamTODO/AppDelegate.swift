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
import FirebaseMessaging
import GoogleMobileAds
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
           if granted {
               DispatchQueue.main.async {
                   // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
//                   application.registerForRemoteNotifications()  푸시 알림 등록
                   UIApplication.shared.registerForRemoteNotifications()
               }
           }
       }
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        
        realmMigration()
        return true
    }
    
    private func realmMigration() {
        RealmMigrationManager.shared.performMigration()
    }
    
    // APNS 토큰을 성공적으로 받으면 Firebase에 등록
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Firebase에 APNS 토큰 전달
        Messaging.messaging().apnsToken = deviceToken
        print("deviceToken \(deviceToken)")
        // APNS 토큰을 String으로 변환 (Base64 인코딩)
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNS token: \(tokenString)")
        
        // FCM 토큰 저장 함수 호출
        saveAPNSToken(tokenString)
    }
    
    // APNS 등록 실패시 호출되는 메서드
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("Firebase registration token: \(token)")
        
        // Firebase에서 받은 FCM 토큰을 저장하거나 처리하는 로직
        let dataDict: [String: String] = ["token": token]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        // FCM 토큰을 로컬에 저장
        saveFCMToken(token)
    }
    
    
}

// MARK: - UNUserNotificationCenterDelegate
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Foreground(앱 켜진 상태)에서 알림을 어떻게 처리할지 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
        let userInfo = notification.request.content.userInfo
        print(userInfo)
    }
    
    // 유저가 푸시를 클릭했을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        

        completionHandler()
    }
}

fileprivate func saveFCMToken(_ token: String) {
    let userDefaults = UserDefaults.standard
    let tokenKey = "fcmToken"
    
    // 저장된 토큰과 비교하여 업데이트 여부를 결정
    if userDefaults.string(forKey: tokenKey) != token {
        userDefaults.set(token, forKey: tokenKey)
        print("Updated FCM token: \(token)")
    } else {
        print("Existing FCM token: \(token)")
    }
}


fileprivate func saveAPNSToken(_ token: String) {
    let userDefaults = UserDefaults.standard
    let tokenKey = "apnsToken"
    
    // 저장된 토큰과 비교하여 업데이트 여부를 결정
    if userDefaults.string(forKey: tokenKey) != token {
        userDefaults.set(token, forKey: tokenKey)
        print("Updated apnsToken: \(token)")
    } else {
        print("Existing apnsToken: \(token)")
    }
}
