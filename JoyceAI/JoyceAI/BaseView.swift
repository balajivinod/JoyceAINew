//
//  BaseView.swift
//  JoyceAI
//
//  Created by C119142 on 5/25/24.
//

import SwiftUI

private enum Constants {
    static let imageSize = 30.0
}
struct BaseView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            VStack {
                content
                Spacer()
            }
            
            VStack {
                Spacer()
//                BottomToolbar(selectedTab: $selectedTab)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct BottomToolbar: View {
    @Binding var selectedTab: Int
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                // Home action
                selectedTab = 0
            }) {
                VStack {
                    Image("chat")
                        .resizable()
                        .frame(width: Constants.imageSize,
                               height: Constants.imageSize)
                }
            }
            Spacer()
            
            Button(action: {
                selectedTab = 1
            }) {
                VStack {
                    Image("avatars")
                        .resizable()
                        .frame(width: Constants.imageSize,
                               height: Constants.imageSize)
                }
            }
            Spacer()
            
            Button(action: {
                // Profile action
                selectedTab = 2
            }) {
                VStack {
                    Image("history")
                        .resizable()
                        .frame(width: Constants.imageSize,
                               height: Constants.imageSize)
                }
            }
            Spacer()
            
            Button(action: {
                // Profile action
                selectedTab = 3
            }) {
                VStack {
                    Image("account")
                        .resizable()
                        .frame(width: Constants.imageSize,
                               height: Constants.imageSize)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .border(Color.gray, width: 0.5)
    }
}

#Preview {
    BaseView {
        let viewModel = FirstTabViewModel()
        FirstTabView(viewModel: viewModel)
    }
}
