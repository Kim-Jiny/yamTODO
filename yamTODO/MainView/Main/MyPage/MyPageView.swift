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
            appSettingSection
            fordDeveloper
        }
      }
      .navigationBarTitle("마이 페이지")
    }
  }
}


private extension MyPage {
  // MARK: View
    var appInfoSection: some View {
      Section(header: Text("앱 정보").fontWeight(.medium)) {
          if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
              Text("현재 앱버전 v\(appVersion)")
                  .frame(height: 44)
          }
          Button {
              isShowNotice = true
          } label: {
              Text("공지사항")
          }.alert(Text(""), isPresented: $isShowNotice, presenting: $isShowNotice, actions: { _ in
              Button("확인", role: .cancel) {
                
              }
            }, message: { _ in
              Text("개발중입니다 🤖")
            })
          .frame(height: 44)
      }
    }
  var taskInfoSection: some View {
    Section(header: Text("반복 설정").fontWeight(.medium)) {
        Button {
            isShowRepeatView = true
        } label: {
            Text("반복 할 일 수정")
        }.sheet(isPresented: $isShowRepeatView) {
            RepeatSettingView()
        }
        .frame(height: 44)
    }
  }
  
    var appSettingSection: some View {
        Section(header: Text("앱 설정").fontWeight(.medium)) {
            Toggle("알림 설정", isOn: $isAppNotice)
            .frame(height: 44)

        //      productHeightPicker
        }
    }
    var fordDeveloper: some View {
      Section(header: Text("소통하기").fontWeight(.medium)) {
          
          Button {
              if MFMailComposeViewController.canSendMail() {
                  self.isShowingMailView.toggle()
              } else {
                  self.showFailedMailAlert = true
              }
          } label: {
              Text("개발자에게 이메일 보내기")
          }
          .sheet(isPresented: $isShowingMailView) {
              MailComposeViewController(isShowing: self.$isShowingMailView)
          }.alert(isPresented: $showFailedMailAlert) {
              Alert(title: Text("이메일 전송 불가"), message: Text("이 기기에서 이메일을 보낼 수 없습니다."), dismissButton: .default(Text("확인")))
          }
          .frame(height: 44)
        
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
