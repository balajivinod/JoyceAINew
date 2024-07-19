//
//  HistoryView.swift
//  JoyceAI
//
//  Created by C119142 on 5/25/24.
//

import SwiftUI

private enum Constants {
    static let backgroundColor = Color("background")
    static let chatBackgroundColor = Color("chatbackground")
}

struct ChatHistory: Identifiable {
    let id = UUID()
    let time: String
    let data: String
}

public struct HistoryView: View {
    let history = [ ChatHistory(time: "Today 12:38pm EST", data: "Hi Joyce! Can you draft an email to my team letting them know we need to..."),
                    ChatHistory(time: "Today 9:32am EST", data: "Hi Joyce! Can you remind me to email Jane when I get into the office?"),
                    ChatHistory(time: "Yesterday 3:29pm EST", data: "What does my schedule look like for next week? Can I meet with Ray about the..."),
                    ChatHistory(time: "Monday, April 22 4:03pm EST", data: "The A/C at the office is out. Can you draft an email to the team to let them know to..."),
                    ChatHistory(time: "Friday, April 19 2:21pm EST", data: "Hey Joyce. Draft an email to Dan to let him know his PTO was approved for his trip...")
    ]

    public var body: some View {
        navigationHeaderView
        NavigationStack {
            ScrollView {
                Spacer()
                    .frame(height: 30.0)
                Text("History")
                    .appFont(.montserrat, weight: .semiBold, size: 24.0, relativeTo: .body)
                Spacer()
                    .frame(height: 30.0)
                ForEach(history) { history in
                    VStack(spacing: 10.0) {
                        HStack {
                            Text(history.time)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .appFont(.montserrat, weight: .semiBold, size: 15.0, relativeTo: .body)
                            Spacer()
                            Image("arrow")
                                .resizable()
                                .frame(width: 17.0, height: 10.0)
                            
                        }
                        .padding([.leading, .trailing])
                        .padding(.top, 10)
                        HStack {
                            Text(history.data)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .appFont(.montserrat, weight: .medium, size: 14.0, relativeTo: .body)
                        }
                        .padding([.leading, .trailing])
                        .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10.0)
                    .padding([.leading, .trailing], 30.0)
                    .padding([.top, .bottom], 5.0)

                }
            }
            .background(Constants.chatBackgroundColor)
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension HistoryView {
    public var navigationHeaderView: some View {
        HStack(alignment: .center) {
            HStack {
                EmptyView()
            }
            .frame(maxWidth: .infinity)
            HStack {
                joyceLogo
            }
            .frame(maxWidth: .infinity)
            HStack {
                menuButton
            }
            .padding(.trailing, 25)
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.white)
    }

    private var menuButton: some View {
        Button { } label: {
            Image("dotspurple")
                .resizable()
                .frame(width: 20, height: 5)
        }
    }

    private var joyceLogo: some View {
        Button { } label: {
            Image("headerpurple")
                .resizable()
                .frame(width: 165, height: 40)
        }
    }
}
#Preview {
    HistoryView()
}
