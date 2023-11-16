//
//  LoginView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import Foundation
import SwiftUI

struct LoginView: View {
  @State private var showTaskList = false
  @State private var showGuestAlert = false
  
  var body: some View {
    VStack {
      guest
        .onTapGesture {
          self.showGuestAlert.toggle()
        }
        .alert(Text("경고"), isPresented: $showGuestAlert, presenting: $showGuestAlert, actions: { _ in
          Button("확인", role: .none) {
            self.showTaskList = true
          }
          Button("취소", role: .cancel) {
            
          }
        }, message: { _ in
          Text("Guest로 입장시 데이터가 누락될 수 있습니다.")
        })
        .fullScreenCover(isPresented: self.$showTaskList) {
//          CalenderView(month: .now)
//          TaskListView().environmentObject(UserData())
          TaskMainView()
        }
      google
    }
  }
  
  private var guest: some View {
    HStack {
      Image("guest")
        .resizable()
        .frame(width: 30, height: 30)
      Text("Guest")
        .foregroundColor(.black)
    }
  }
  
  private var google: some View {
    HStack {
      Image("google")
        .resizable()
        .frame(width: 30, height: 30)
      Text("Google Login")
    }
  }
}
