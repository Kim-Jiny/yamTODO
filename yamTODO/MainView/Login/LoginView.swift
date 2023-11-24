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
        .alert(Text("Notice"), isPresented: $showGuestAlert, presenting: $showGuestAlert, actions: { _ in
          Button("OK", role: .none) {
            self.showTaskList = true
          }
          Button("Cancel", role: .cancel) {
            
          }
        }, message: { _ in
          Text("If you use the app as a Guest, data will be stored locally. You can log in later.")
        })
        .fullScreenCover(isPresented: self.$showTaskList) {
//          CalenderView(month: .now)
//          TaskListView().environmentObject(UserData())
//          TaskMainView()
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
