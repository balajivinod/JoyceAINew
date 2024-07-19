//
//  JoyceAIApp.swift
//  JoyceAI
//
//  Created by C119142 on 5/22/24.
//

import SwiftUI

@main
struct JoyceAIApp: App {
    init() {
        CommonFonts.registerFonts()
//        UITabBar.appearance().backgroundColor = ViewConstants.tabBarBackgroundColor
//        UITabBar.appearance().unselectedItemTintColor = ViewConstants.unSelectedTabColor
    }
    var body: some Scene {
        WindowGroup {
//            JoyceLogin()
            SpeechToTextView()
        }
    }
}


//headers = {
//    "Content-Type": "application/json",
//    "Authorization": "Bearer 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"
//    "OpenAI-Project": "proj_Wc9xYn1KYmaBcaw6qiwWb02N",
//    "OpenAI-Organization": "org-Pz3tdIBYSUpL0DIlrj4bWgfu"
//}

//https://api.openai.com/v1/chat/completions
