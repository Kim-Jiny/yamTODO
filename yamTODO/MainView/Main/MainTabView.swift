//
//  MainTabView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/31.
//

import SwiftUI

struct MainTabView: View {
  private enum Tabs {
    case home, calendar, gallery, myPage
  }
  
  @State private var selectedTab: Tabs = .home
  
  // MARK: Body
  
  var body: some View {
    TabView(selection: $selectedTab) {
      Group {
        home
        calendar
//        imageGallery
        myPage
      }
      .accentColor(.primary)
    }
    .accentColor(.yamSky)
    .edgesIgnoringSafeArea(edges)
//    .statusBar(hidden: selectedTab == .recipe)
  }
}


private extension MainTabView {
  // MARK: View
  
  var home: some View {
    TaskMainView()
      .tag(Tabs.home)
      .tabItem(image: "house", text: "홈")
  }
  
  var calendar: some View {
      CalendarMainView()
      .tag(Tabs.calendar)
      .tabItem(image: "calendar", text: "캘린더")
  }
  
//  var imageGallery: some View {
//    ImageGallery()
//      .tag(Tabs.gallery)
//      .tabItem(image: "photo.on.rectangle", text: "갤러리")
//  }
  
  var myPage: some View {
    MyPage()
      .tag(Tabs.myPage)
      .tabItem(image: "person", text: "마이페이지")
  }
  
  // MARK: Computed Values
  
  var edges: Edge.Set {
    if #available(iOS 13.4, *) {
      return .init()
    } else {
      return .top
    }
  }
}


// MARK: - View Extension

fileprivate extension View {
  func tabItem(image: String, text: String) -> some View {
    self.tabItem {
      Symbol(image, scale: .large)
        .font(Font.system(size: 17, weight: .light))
      Text(text)
    }
  }
}


