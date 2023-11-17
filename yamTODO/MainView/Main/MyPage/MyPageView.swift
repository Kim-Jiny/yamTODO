//
//  MyPageView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/31.
//

import SwiftUI

struct MyPage: View {
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
//    .sheet(isPresented: $isPickerPresented) {
//      ImagePickerView(pickedImage: self.$pickedImage)
//    }
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
              isShowRepeatView = true
          } label: {
              Text("문의하기")
          }.sheet(isPresented: $isShowRepeatView) {
              RepeatSettingView()
          }
          .frame(height: 44)
          
          Button {
              isShowRepeatView = true
          } label: {
              Text("개발자에게 후원하기")
          }.sheet(isPresented: $isShowRepeatView) {
              RepeatSettingView()
          }
          .frame(height: 44)
      }
    }
}

