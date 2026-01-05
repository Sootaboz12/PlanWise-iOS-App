//
//  MainTabView.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var homeViewId = UUID()
    @State private var previousTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .id(homeViewId)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                .transition(.asymmetric(
                    insertion: .move(edge: previousTab < 0 ? .leading : .trailing).combined(with: .opacity),
                    removal: .move(edge: previousTab < 0 ? .trailing : .leading).combined(with: .opacity)
                ))
                .onChange(of: selectedTab) { oldValue, newValue in
                    if newValue == 0 {
                        homeViewId = UUID()
                    }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        previousTab = oldValue
                    }
                }
            
            RecentNoteView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Recent")
                }
                .tag(1)
                .transition(.asymmetric(
                    insertion: .move(edge: previousTab < 1 ? .leading : .trailing).combined(with: .opacity),
                    removal: .move(edge: previousTab < 1 ? .trailing : .leading).combined(with: .opacity)
                ))
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
                .transition(.asymmetric(
                    insertion: .move(edge: previousTab < 2 ? .leading : .trailing).combined(with: .opacity),
                    removal: .move(edge: previousTab < 2 ? .trailing : .leading).combined(with: .opacity)
                ))
        }
        .accentColor(.appPurple)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
