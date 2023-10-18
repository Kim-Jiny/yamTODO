//
//  ContentView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      TaskMainView()
//      NavigationView {
//        TaskListView().environmentObject(UserData())
//        VStack {
//
//          //MARK: - For Test
//          TaskListView().environmentObject(UserData())
////          LoginView()
//        }
//        .padding()
//          .navigationBarHidden(true)
//      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
