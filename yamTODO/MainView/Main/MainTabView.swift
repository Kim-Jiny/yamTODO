//
//  MainTabView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/31.
//
import SwiftUI

enum Tabs {
    case home, calendar, gallery, myPage
}

struct MainTabView: View {
    @ObservedObject var userColor = UserColorObject()
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                home
                calendar
//              imageGallery
                myPage
            }
            .accentColor(.primary)
        }
        .accentColor(userColor.userColorData.selectedColor.darkColor.toColor())
        .edgesIgnoringSafeArea(edges)
//      .statusBar(hidden: selectedTab == .recipe)
    }
    
    private var home: some View {
        TaskMainView(userColor: userColor, selectedTab: $selectedTab)
            .tag(Tabs.home)
            .tabItem(image: "house", text: Text("Home"))
    }
    
    private var calendar: some View {
        CalendarMainView(userColor: userColor, selectedTab: $selectedTab)
            .tag(Tabs.calendar)
            .tabItem(image: "calendar", text: Text("Calendar"))
    }
    
//    private var imageGallery: some View {
//        ImageGallery()
//            .tag(Tabs.gallery)
//            .tabItem(image: "photo.on.rectangle", text: "갤러리")
//    }
    
    private var myPage: some View {
        MyPage(userColor: userColor)
            .tag(Tabs.myPage)
            .tabItem(image: "person", text: Text("Mypage"))
    }
    
    private var edges: Edge.Set {
        if #available(iOS 13.4, *) {
            return .init()
        } else {
            return .top
        }
    }
}

fileprivate extension View {
    func tabItem(image: String, text: Text) -> some View {
        self.tabItem {
            Symbol(image, scale: .large)
                .font(Font.system(size: 17, weight: .light))
            text
        }
    }
}
