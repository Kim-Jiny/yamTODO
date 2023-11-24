//
//  yamTODOApp.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct yamTODOApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
      WindowGroup {
        ContentView()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
                // 사용자 권한 동의 관한 답변을 받아서
                 // 광고 영역을 잡을지 말지 
                })
            }
      }
  }
    
    init() {
        // DispatchQueue 이용
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        }
      }

}
