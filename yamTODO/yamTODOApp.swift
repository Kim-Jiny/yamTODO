//
//  yamTODOApp.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import SwiftUI

@main
struct yamTODOApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
//      NavigationView {
        ContentView()
//      }
    }
    
  }
}
