//
//  MainTabView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/31.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var userColor = UserColorObject()
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
    .accentColor(userColor.userColorData.selectedColor.darkColor.toColor())
    .edgesIgnoringSafeArea(edges)
//    .statusBar(hidden: selectedTab == .recipe)
  }
}


private extension MainTabView {
  // MARK: View
  
  var home: some View {
    TaskMainView(userColor: userColor)
      .tag(Tabs.home)
      .tabItem(image: "house", text: Text("Home"))
  }
  
  var calendar: some View {
      CalendarMainView(userColor: userColor)
      .tag(Tabs.calendar)
      .tabItem(image: "calendar", text: Text("Calendar"))
  }
  
//  var imageGallery: some View {
//    ImageGallery()
//      .tag(Tabs.gallery)
//      .tabItem(image: "photo.on.rectangle", text: "갤러리")
//  }
  
  var myPage: some View {
    MyPage(userColor: userColor)
      .tag(Tabs.myPage)
      .tabItem(image: "person", text: Text("Mypage"))
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
  func tabItem(image: String, text: Text) -> some View {
    self.tabItem {
      Symbol(image, scale: .large)
        .font(Font.system(size: 17, weight: .light))
      text
    }
  }
}


