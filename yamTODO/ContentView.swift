//
//  ContentView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      NavigationView {
        VStack {
          LoginView()
        }
        .padding()
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
