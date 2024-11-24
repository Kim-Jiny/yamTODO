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
    @Binding var selectedTab: Tabs // 외부에서 상태를 전달받음
    // scene의 생명주기를 확인하는 코드
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var today = TaskList(date: Date().getStartTime())
    
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
        
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                // 앱이 활성화될 때 수행할 작업
                print("앱이 활성화되었습니다.")
                if Date().getStartTime() != today.date {
                    // 앱이 활성화 되었는데 오늘 날짜가 달라졌으면 캘린더를 새로 부르자
                    print("날짜가 다르다")
                    today.date = Date().getStartTime()
                }
            case .inactive:
                // 앱이 비활성화될 때 수행할 작업
                print("앱이 비활성화되었습니다.")
            case .background:
                // 앱이 백그라운드로 이동될 때 수행할 작업
                print("앱이 백그라운드로 이동되었습니다.")
            @unknown default:
                break
            }
        }
    }
    
    private var home: some View {
        TaskMainView(userColor: userColor, selectedTab: $selectedTab, taskList: today)
            .tag(Tabs.home)
            .tabItem(image: "house", text: Text("Home"))
    }
    
    private var calendar: some View {
        CalendarMainView(userColor: userColor, selectedTab: $selectedTab, today: today)
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
