//
//  HomeView.swift
//  Phone
//
//  Created by Louis Chang on 2024/12/13.
//

import SwiftUI
import TipKit
import LocalAuthentication

// 為不同頁面定義獨立的 Tip
struct TabNavigationTip: Tip {
    var title: Text {
        Text("快速切換功能")
    }
    
    var message: Text? {
        Text("點擊下方分頁可以在聯絡人和使用量間快速切換")
    }
}

struct HomeTabTip: Tip {
    var title: Text {
        Text("聯絡人列表")
    }
    
    var message: Text? {
        Text("這裡可以查看所有聯絡人")
    }
}

struct ProfileTabTip: Tip {
    var title: Text {
        Text("聯絡人統計")
    }
    
    var message: Text? {
        Text("查看聯絡人使用圖表")
    }
}

struct HomeView: View {
    @State private var tabTip = TabNavigationTip()
    @State private var homeTabTip = HomeTabTip()
    @State private var profileTabTip = ProfileTabTip()
    @State private var selectedTab = 0
    @State private var isUnlocked = false
    
    var body: some View {
        Group {
            if isUnlocked {
                TabView(selection: $selectedTab) {
                    ContentView()
                        .tabItem {
                            Label("Contact", systemImage: "person.fill")
                        }
                        .tag(0)
                        .overlay(alignment: .top) {
                            if selectedTab == 0 {
                                TipView(homeTabTip)
                                    .padding()
                            }
                        }
                    
                    ContactPieChartView()
                        .tabItem {
                            Label("Usage", systemImage: "chart.pie.fill")
                        }
                        .tag(1)
                        .overlay(alignment: .top) {
                            if selectedTab == 1 {
                                TipView(profileTabTip)
                                    .padding()
                            }
                        }
                }
                .overlay(alignment: .bottom) {
                    TipView(tabTip)
                        .padding(.bottom, 60)
                }
            } else {
                Button("解鎖應用程式") {
                    authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "需要驗證身份才能存取聯絡人資料") { success, error in
                DispatchQueue.main.async {
                    isUnlocked = success
                }
            }
        }
    }
}


#Preview {
    HomeView()
}
