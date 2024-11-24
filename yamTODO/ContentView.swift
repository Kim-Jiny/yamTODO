//
//  ContentView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import SwiftUI

struct ContentView: View {
    @Binding var selectedTab: Tabs
    
    var body: some View {
        MainTabView(selectedTab: $selectedTab)
    }
}
