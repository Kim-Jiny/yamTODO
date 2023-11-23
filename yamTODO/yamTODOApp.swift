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
//      NavigationView {
        ContentView()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
                  }
//      }
    }
      
    
  }
    
    init() {
        // DispatchQueue 이용
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        }
      }

}
