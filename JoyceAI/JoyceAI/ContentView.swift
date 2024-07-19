//
//  ContentView.swift
//  JoyceAI
//
//  Created by C119142 on 5/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var firstTabViewModel = FirstTabViewModel()
    @StateObject private var secondTabViewModel = SecondTabViewModel()
//    var body: some View {
//        switch selectedTab {
//        case 0:
//            FirstTabView(viewModel: firstTabViewModel)
//        case 1:
//            ChatView()
//        case 2:
//            HistoryView()
//        case 3:
//            HistoryView()
//        default:
//            FirstTabView(viewModel: firstTabViewModel)
//        }
//    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                switch selectedTab {
                case 0:
                    FirstTabView(viewModel: firstTabViewModel)
                case 1:
                    FirstTabView(viewModel: firstTabViewModel)
                case 2:
                    HistoryView()
                case 3:
                    AccountsView()
                default:
                    AccountsView()
                }
                Spacer()
            }

            VStack {
                Spacer()
                BottomToolbar(selectedTab: $selectedTab)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    /*
    var body: some View {
            NavigationView {
                ZStack {
                    VStack {
                        Spacer()
                        switch selectedTab {
                        case 0:
                            FirstTabView(viewModel: firstTabViewModel)
                        case 1:
                            FirstTabView(viewModel: firstTabViewModel)
                        case 2:
                            HistoryView()
                        default:
                            FirstTabView(viewModel: firstTabViewModel)
                        }
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        BottomToolbar(selectedTab: $selectedTab)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
     */
}

#Preview {
    ContentView()
}
