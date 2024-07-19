//
//  File.swift
//  JoyceAI
//
//  Created by C119142 on 5/24/24.
//

import Foundation
import SwiftUI
import MessageUI

private enum Constants {
    static let backgroundColor = Color("background")
    static let staticContent = "Hello! How can I assist you today?\nBelow are the topics that we got from the chat history\n1. Skill Development\n2. Process Optimization\n3. Leadership Training\n\nIf you need any further assistance or have any specific preferences, feel free to let me know!"
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatView: View {
    @State private var isShowingMailView = false
    @State var isFirstMessage = true
    @StateObject private var viewModel = ChatViewModel()
    @State var chatResponse: Chat.Response? = nil
    @State var messageText: String = ""
    @State private var messages: [Message] = [
        Message(text: "Hello, how can I help you?", isUser: false),
        Message(text: "I have a question about SwiftUI.", isUser: true)
    ]
    @State private var newMessage: String = ""
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var mailRecipients: [String] = []
    @State private var mailSubject: String = ""
    @State private var mailBody: String = ""
    @Binding var requestModel: Chat.Request
    var body: some View {
        NavigationStack {
            navigationHeaderView
            ZStack {
                VStack {
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0.0) {
                                ForEach(viewModel.messages.indices, id: \.self) { index in
                                    let message = viewModel.messages[index]
                                    if index == 1 && message.role == "user" || message.role == "system" {
//                                        Color.clear
                                        Spacer()
                                            .frame(height: 1.0)
                                    } else {
                                        HStack {
                                            if message.role == "assistant" {
                                                VStack(spacing: .zero) {
                                                    HStack {
                                                        Image("joyce")
                                                            .resizable()
                                                            .frame(width: 26.0,
                                                                   height: 26.0)
                                                        Text("Joyce")
//                                                            .padding()
                                                            .appFont(.montserrat, weight: .bold, size: 14.0, relativeTo: .body)
//                                                            .background(Color.gray.opacity(0.2))
                                                            .cornerRadius(10)
                                                            .foregroundColor(.black)
                                                        Spacer()
                                                    }
                                                    HStack {
                                                        Rectangle()
                                                            .frame(width: 26.0,
                                                                   height: 26.0)
                                                            .foregroundColor(.white)
                                                        let messageText = message.content.contains("\"event_type\": \"email\"") ? "Your email has been sent successfully. Please check your inbox." : message.content

                                                        let revisedMessage = messageText.contains("Hello! How can I assist you today?") ? Constants.staticContent : messageText
                                                        
                                                        Text(revisedMessage)
//                                                            .padding()
                                                            .appFont(.montserrat, weight: .medium, size: 14.0, relativeTo: .body)
//                                                            .background(Color.gray.opacity(0.2))
                                                            .cornerRadius(10)
                                                            .foregroundColor(.black)
                                                        Spacer()
                                                    }
                                                }
                                                .padding(.bottom)
                                            } else {
                                                VStack(spacing: .zero) {
                                                    HStack {
                                                        Image("user")
                                                            .resizable()
                                                            .frame(width: 26.0,
                                                                   height: 26.0)
                                                        Text("Julia")
//                                                            .padding()
                                                            .appFont(.montserrat, weight: .bold, size: 14.0, relativeTo: .body)
//                                                            .background(Color.gray.opacity(0.2))
                                                            .cornerRadius(10)
                                                            .foregroundColor(.black)
                                                        Spacer()
                                                    }
                                                    HStack {
                                                        Rectangle()
                                                            .frame(width: 26.0,
                                                                   height: 26.0)
                                                            .foregroundColor(.white)
                                                        Text(message.content)
//                                                            .padding()
                                                            .appFont(.montserrat, weight: .medium, size: 14.0, relativeTo: .body)
//                                                            .background(Color.gray.opacity(0.2))
                                                            .cornerRadius(10)
                                                            .foregroundColor(.black)
                                                        Spacer()
                                                    }
                                                }
                                                .padding(.bottom)
                                            }
                                        }
                                        .id(message.id)

                                    }
                                }
                            }
                            .padding()
                        }
                        .onChange(of: viewModel.messages.count) { _, _ in
                            // Scroll to the last message when a new message is added
                            if let lastMessageId = viewModel.messages.last?.id {
                                withAnimation {
                                    scrollProxy.scrollTo(lastMessageId, anchor: .bottom)
//                                    if messageText == "send mail" {
//                                        isShowingMailView = true
//                                    }

                                    messageText = ""
//                                    isShowingMailView = true
                                }

                                if let lastmessage = viewModel.messages.last {
                                    if lastmessage.role == "assistant" && lastmessage.content.contains("\"event_type\": \"email\"") {
                                        Task {
                                            let jsonString = extractJSONString(inputString: lastmessage.content)
                                            await viewModel.sendEmail(payloadString: jsonString) { responseCode, success in
                                                if (success != nil) {
                                                    print("Email send successfull")
    //                                                viewModel.appendEMailSuccessResponseToMessages()
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            
                            /*if let lastMessage = viewModel.messages.last {
                                if lastMessage.content.contains("\"event_type\": \"email\"") {
                                    Task {
                                        await viewModel.sendEmail { responseCode, success in
                                            if (success != nil) {
                                                print("Email send successfull")
                                            }
                                        }
                                    }
                                }
                            }*/
                        }
                        .safeAreaInset(edge: .bottom, spacing: .zero) {
                            Spacer()
                                .frame(height: 80.0)
                        }
                    }
                    ZStack{
                        VStack(spacing: 0.0) {
                            HStack {
                                TextField("Start typing...", text: $messageText)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .frame(height: 50)
                            }
                            .padding(.leading)
                            .padding(.top)
                            .background(Color.chatbackground)
                            Rectangle()
                                .frame(height: 100)
                                .foregroundColor(Color.chatbackground)
                        }
                        .cornerRadius(30.0)

                        Button(action: {
                            
                            isFirstMessage = false
                            
                            if messageText == "send email" {
                                configureMail()
                            } else {
                                viewModel.sendMessage(messageText,
                                                      isUser: true,
                                                      isFirstRequest: isFirstMessage)
                            }
                            
                        }) {
                            Image("send")
                                .resizable()
                                .frame(width: 47.0, height: 47.0)
                        }
                        .padding(.bottom, 160)
                        .padding(.trailing, 30)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(height: 30.0)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .onAppear() {
            print("view model messages: \(viewModel.messages)")
            let requestChatHistory = "Enhancing professional skills for the leadership roles. Streamlining operations for better efficiency. Provide three two word topics in JSON array format with topics as object and if you are not able to find the topics then send JSON as an empty string with topics as object."
            viewModel.sendMessage("Hello!",
                                  isUser: true,
                                  isFirstRequest: isFirstMessage)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: $mailResult, recipients: mailRecipients, subject: mailSubject, body: mailBody)
        }
        //        .navigationBarBackButtonHidden(true)
    }

    func replaceTextBetweenMarkers(in text: String, startMarker: String, endMarker: String, with replacement: String) -> String {
        var result = text
        while let startRange = result.range(of: startMarker),
              let endRange = result.range(of: endMarker, range: startRange.upperBound..<result.endIndex) {
            let rangeToReplace = startRange.upperBound..<endRange.lowerBound
            result.replaceSubrange(rangeToReplace, with: replacement)
        }
        return result
    }

    func replaceFromMarkerToEnd(in text: String, marker: String, with replacement: String) -> String {
        if let range = text.range(of: marker) {
            let startOfReplacement = range.description.startIndex
            let rangeToReplace = startOfReplacement..<text.endIndex
            var result = text
            result.replaceSubrange(rangeToReplace, with: replacement)
            return result
        } else {
            return text
        }
    }

    private func configureMail() {
        // Configure the email details here
        mailRecipients = ["example@example.com"] // Replace with actual recipient
        mailSubject = "Subject goes here"
        mailBody = "Body of the email goes here"
    }

    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        messages.append(Message(text: newMessage, isUser: true))
        newMessage = ""
    }
    
    private func extractJSONString(inputString: String) -> String {
        // Define a regular expression pattern to extract the JSON object
        let pattern = "\\{[\\s\\S]*?\\}"

        // Create a regular expression object
        do {
            let regex = try NSRegularExpression(pattern: pattern)

            // Perform the search
            if let match = regex.firstMatch(in: inputString, range: NSRange(inputString.startIndex..., in: inputString)) {
                // Extract the matched substring
                if let range = Range(match.range, in: inputString) {
                    let jsonString = String(inputString[range])
                    print("Extracted JSON String: \(jsonString)")
                    
                    // Optionally parse the JSON string to verify its structure
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            var jsonObject: [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] ?? [:]
                            jsonObject["event_id"] = UUID().uuidString
                            
                            print("Parsed JSON Object: \(jsonObject)")
                            
                            let updatedJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                            
                            // Convert the JSON data back to a string
                            if let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
                                print("Updated JSON String: \(updatedJsonString)")
                                return updatedJsonString
                                // Now you can use the updated JSON string for further processing or sending in a POST request
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                } else {
                    print("No JSON object found in the input string.")
                }
            }
        } catch {
            print("Invalid regular expression: \(error)")
        }

        return ""
    }

    private func sendChat(inputText: String,
                          chatPayload: Chat.Request, completion: @escaping (Chat.Response?, String?) -> Void) async {
        do {
            // Create the URL
            guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
                completion(nil, "Invalid URL.")
                return
            }

            // Create the request body
            
            // Convert the body to JSON data
//            guard let jsonData = try? JSONSerialization.data(withJSONObject: chatPayload) else {
//                completion(false, "Invalid request body.")
//                return
//            }

            //JSON encoder is used to encode model objects into jsondata
            
            let jsonData = try JSONEncoder().encode(chatPayload)
            print("Subsequent Request \(chatPayload)")
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
            request.setValue("proj_Wc9xYn1KYmaBcaw6qiwWb02N", forHTTPHeaderField: "OpenAI-Project")
            request.setValue("org-Pz3tdIBYSUpL0DIlrj4bWgfu", forHTTPHeaderField: "OpenAI-Organization")

            request.httpBody = jsonData
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                completion(nil, "Fetch Chat failed. Please try again.")
                return
              }

            let chatResponse = try JSONDecoder().decode(Chat.Response.self, from: data)
            let choices = chatResponse.choices
            let message = choices?[0].message
            let role = message?.role ?? ""
            let content = message?.content ?? ""
            let responseMessage = Chat.Request.MessageModel(role: "assistant", content: content)
            let requestSubModel = Chat.Request.MessageModel(role: "user", content: inputText)
            requestModel.messages.append(requestSubModel)
            print("subsequent Response \(responseMessage)")
            completion(chatResponse, "success")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(Color.chatbackground)
            .cornerRadius(5)
            .appFont(.montserrat, weight: .medium, size: 14.0, relativeTo: .body)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let systemMessage = Chat.Request.MessageModel(role: "system",
                                         content: "You are a helpful assistant.")
        let userMessage = Chat.Request.MessageModel(role: "user",
                                       content: "Hello!")
        let model: String = "gpt-3.5-turbo-0125"
        @State var requestModel: Chat.Request = Chat.Request(model: "gpt-3.5-turbo-0125", temperature: 0.1,
                                                             messages: [systemMessage, userMessage])
        ChatView(requestModel: $requestModel)
    }
}

extension ChatView {
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
