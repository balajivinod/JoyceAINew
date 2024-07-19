//
//  AvatarView.swift
//  JoyceAI
//
//  Created by C119142 on 5/25/24.
//

import Foundation
import SwiftUI

private enum Constants {
    static let backgroundColor = Color("background")
    static let chatBackgroundColor = Color("chatbackground")
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
}

struct SectionData: Identifiable {
    let id = UUID()
    let title: String
    let items: [Item]
}

let sections = [
    SectionData(title: "Accounts", items: [
        Item(name: "Account Settings"),
        Item(name: "Subscriptions"),
    ]),
    SectionData(title: "Permissions", items: [
        Item(name: "Theme"),
        Item(name: "Avatar Default"),
    ]),
    SectionData(title: "Other", items: [
        Item(name: "Region and Language"),
        Item(name: "Privacy"),
        Item(name: "Permissions")
    ])
]

struct AccountsView: View {
    let sections = [
        SectionData(title: "Accounts", items: [
            Item(name: "Account Settings"),
            Item(name: "Subscriptions"),
        ]),
        SectionData(title: "Permissions", items: [
            Item(name: "Theme"),
            Item(name: "Avatar Default"),
        ]),
        SectionData(title: "Other", items: [
            Item(name: "Region and Language"),
            Item(name: "Privacy"),
            Item(name: "Permissions")
        ])
    ]
    var body: some View {
            NavigationStack {
                navigationHeaderView
                ScrollView {
                    Spacer()
                        .frame(height: 30.0)
                    Text("My Account")
                        .appFont(.montserrat, weight: .semiBold, size: 24.0, relativeTo: .body)
                    Spacer()
                        .frame(height: 20.0)
                    Image("profile")
                        .resizable()
                        .frame(width: 102.0, height: 102.0)
                    Spacer()
                        .frame(height: 20.0)
                    VStack(alignment: .leading, spacing: 20) {  // Adjust the spacing between sections
                        ForEach(sections) { section in
                            VStack(alignment: .leading) {
                                Text(section.title)
                                    .appFont(.montserrat, weight: .medium, size: 13.0, relativeTo: .body)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                ForEach(section.items) { item in
                                    NavigationLink(destination: Text("Detail View for \(item.name)")) {
                                        HStack {
                                            Text(item.name)
                                                .padding()
                                                .appFont(.montserrat, weight: .medium, size: 15.0, relativeTo: .body)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                                .padding(.trailing)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 33.0)
                                        .background(Color(.systemBackground))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(Constants.chatBackgroundColor)
            }
            .navigationBarBackButtonHidden(true)
    }
}

extension AccountsView {
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

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
