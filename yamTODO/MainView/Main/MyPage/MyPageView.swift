//
//  MyPageView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/31.
//

import SwiftUI
import UIKit
import MessageUI

struct MyPage: View {
    @State private var isShowingMailView = false
    @State private var showFailedMailAlert = false
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var isShowNotice: Bool = false
    @State var isShowRepeatView: Bool = false
    @State private var isAppNotice: Bool = false
  // MARK: Body
  
  var body: some View {
    NavigationView {
      VStack {
//        userInfo
        
        Form {
            appInfoSection
            taskInfoSection
//            appSettingSection
            fordDeveloper
        }
      }
      .navigationBarTitle("My Page")
        
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}


private extension MyPage {
  // MARK: View
    var appInfoSection: some View {
      Section(header: Text("App settings").fontWeight(.medium)) {
          if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
              Text("App version v\(appVersion)")
                  .frame(height: 44)
          }
//          Button {
//              scheduleNotification()
////              isShowNotice = true
//          } label: {
//              Text("공지사항")
//          }
//          .alert(Text(""), isPresented: $isShowNotice, presenting: $isShowNotice, actions: { _ in
//              Button("확인", role: .cancel) {
//                
//              }
//            }, message: { _ in
//              Text("개발중입니다 🤖")
//            })
//          .frame(height: 44)
      }
    }
  var taskInfoSection: some View {
    Section(header: Text("Recurring schedule").fontWeight(.medium)) {
        NavigationLink(destination: RepeatSettingView()) {
            Text("Setting up a recurring schedule")
        }
//        Button {
//            isShowRepeatView = true
//        } label: {
//            Text("반복 할 일 수정")
//        }.sheet(isPresented: $isShowRepeatView) {
//            RepeatSettingView()
//        }
        .frame(height: 44)
    }
  }
  
//    var appSettingSection: some View {
//        Section(header: Text("앱 설정").fontWeight(.medium)) {
//            Toggle("알림 설정", isOn: $isAppNotice)
//            .frame(height: 44)
//
//        //      productHeightPicker
//        }
//    }
    var fordDeveloper: some View {
      Section(header: Text("Communication").fontWeight(.medium)) {
          
          Button {
              if MFMailComposeViewController.canSendMail() {
                  self.isShowingMailView.toggle()
              } else {
                  self.showFailedMailAlert = true
              }
          } label: {
              Text("Send feedback to the developer (Inquiry)")
          }
          .sheet(isPresented: $isShowingMailView) {
              MailComposeViewController(isShowing: self.$isShowingMailView)
          }.alert(isPresented: $showFailedMailAlert) {
              Alert(title: Text("Unable to send email"), message: Text("You cannot send emails from this device."), dismissButton: .default(Text("OK")))
          }
          .frame(height: 44)
        
      }
    }
    
    func scheduleNotification() {
            let content = UNMutableNotificationContent()
            content.title = "알림 제목"
            content.body = "알림 본문"
            content.sound = UNNotificationSound.default

            // 알림이 표시되는 시간 설정 (예: 10초 후)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

            // 알림 요청 생성
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // 요청을 notification center에 추가
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding notification request: \(error.localizedDescription)")
                } else {
                    print("Notification request added successfully")
                }
            }
        }
}

extension ContentView {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}
extension Result {
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }

    var isFailure: Bool {
        return !isSuccess
    }
}
