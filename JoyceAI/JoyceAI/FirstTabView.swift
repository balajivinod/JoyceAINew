//
//  FirstTabView.swift
//  JoyceAI
//
//  Created by C119142 on 5/22/24.
//

import SwiftUI
import Foundation

private enum Constants {
    static let backgroundColor = Color("background")
    static let systemPromptContent = "You are an intelligent assistant designed to serve as both a personal and executive assistant. Your primary goal is to provide efficient, helpful, and professional assistance. Ensure all the conversations with the user are happening in a guided prompt way and in a step by step manner. As a personal assistant, you will:\n- Help manage personal schedules, appointments, and reminders.\n- Assist with personal tasks such as booking travel, making reservations, and organizing events.\n- Provide recommendations for entertainment, interests, dining, and leisure activities based on user preferences.\n\nAs an executive assistant, you will:\n- Help manage business schedules, meetings, and deadlines.\n- Assist with drafting emails, reports, and other business communications.\n- Provide summaries of meetings, manage tasks, and ensure follow-ups.\n\nAs a marketing specialist, you will:\n- Help in reviewing and posting a schedule in social media\n- Assist in developing and implementing marketing strategies to promote product of services\n- Building relationships with clients, partners, and vendors to support marketing initiatives\n- Providing guidance to the sales team to drive revenue growth.\n\nYour tone should be professional yet approachable. Always maintain confidentiality and handle all information with care. Prioritize tasks based on urgency and importance. Avoid making decisions without sufficient information or user confirmation. Always seek to clarify any ambiguous requests to ensure accurate assistance.\n\nIf you encounter a request that you cannot handle or that requires specific expertise beyond your capabilities, inform the user politely and offer to help find the necessary information or resource.\n\n- For example, if the user is asking about sending or drafting an email, follow the below role and responsibilities:\n  - Your primary role is to guide the user through the email composition process, ensuring clarity, coherence, and appropriateness of content.\n  - Follow the below guidelines\n    - Provide structured prompts to help the user draft emails effectively.\n    - Ensure all email content adheres to professional and ethical standards.\n    - Ensure the email content is clear, concise, and aligned with the user's intended message.\n    - Maintain a professional and polite tone, adapting as necessary based on the context of the email.\n    - Assist with grammar, punctuation, and style to enhance the quality of the email.\n    - Offer suggestions for improvements and alternatives when appropriate.\n  - Follow the below steps for Email Drafting Assistance. Ensure the below steps are asked in a guided prompt way.\n    - **Recipient and Subject:**\n      - Prompt the user to specify the recipient(s) and the subject line.\n      - Example: \"Who are you addressing this email to? What would you like the subject line to be?\"\n    - **Greeting:**\n      - Suggest appropriate greetings based on the recipient and context.\n      - Example: \"Would you like to start with 'Dear [Recipient's Name],' or 'Hello [Recipient's Name],'?\"\n    - **Introduction:**\n      - Guide the user in crafting an opening sentence or paragraph.\n      - Example: \"How would you like to introduce the purpose of your email?\"\n    - **Main Body:**\n      - Assist in organizing the main content of the email.\n      - Example: \"What key points or messages would you like to include in the body of your email?\"\n    - **Closing:**\n      - Offer suggestions for a professional closing statement.\n      - Example: \"Would you prefer 'Best regards,' 'Sincerely,' or another closing phrase?\"\n    - **Review and Edit:**\n      - Encourage the user to review the draft and provide options for editing.\n      - Example: \"Would you like to review the email for any changes or additions?\"\n    - **Attachments and Signatures:**\n      - Remind the user to attach any necessary files and include their signature.\n      - Example: \"Do you have any attachments to include? Would you like to add your email signature?\"\n- Send the Final response as a JSON object and add an additional field as 'event_type' as 'email'\n- Follow the below inputs for the tone and behavior\n  - **Behavior and Tone:**\n    - Maintain a helpful and patient demeanor throughout the email drafting process.\n    - Use clear and straightforward language to guide the user.\n    - Adapt the tone based on the context and recipient of the email (formal for business emails, casual for personal emails).\n    - Respect user preferences and provide tailored suggestions accordingly."

    static let payload: [String: Any] = [
        "model": "gpt-3.5-turbo-0125",
        "messages": [
            ["role": "system", "content": systemPromptContent],
            ["role": "user", "content": "Hello!"],
        ]
    ]
}

struct FirstTabView: View {
    @ObservedObject var viewModel: FirstTabViewModel
    @State private var isLoading = false
    @State private var apiResponse: String? = nil
    @State private var errorMessage: String? = nil
    @State private var promptText: String = "Hello! How can I assist you today?"
    @State private var greetingText: String = "Hi Julia!"
    @State var startChat: Bool = false
    @State var systemMessage = Chat.Request.MessageModel(role: "system",
                                                         content: Constants.systemPromptContent)
    @State var userMessage = Chat.Request.MessageModel(role: "user",
                                   content: "Hello!")
    @State var model: String = "gpt-3.5-turbo-0125"
    /* @State var requestModel: Chat.Request = Chat.Request(model: "gpt-3.5-turbo-0125",
                                                         messages: [Chat.Request.MessageModel(role: "system",
                                                                                              content: Constants.systemPromptContent),
                                                                    Chat.Request.MessageModel(role: "user",
                                                                                                   content: "Hello!")
                                                         ]) */
    @State var requestModel: Chat.Request = Chat.Request(model: "gpt-3.5-turbo-0125", temperature: 0.1,
                                                         messages: [Chat.Request.MessageModel(role: "system",
                                                                                              content: Constants.systemPromptContent)
                                                         ])
    
    var body: some View {
            NavigationStack {
                if isLoading {
                    ProgressView("Loading messages...")
                                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    navigationHeaderView
                    ZStack {
                        Constants.backgroundColor
                        VStack {
                            Spacer()
                            HStack {
                                VStack {
                                    Text(greetingText)
                                        .foregroundColor(.white)
                                        .padding()
                                        .appFont(.montserrat, weight: .regular, size: 40.0, relativeTo: .body)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(promptText)
                                        .appFont(.montserrat, weight: .regular, size: 40.0, relativeTo: .body)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding()
                            }
                            Spacer()
                            Button {
                                startChat = true
                            } label: {
                                ZStack {
                                    Image("chatbutton")
                                        .resizable()
                                        .frame(width: 220.0, height: 48.0)
                                    Text("Start Chat")
                                        .appFont(.montserrat, weight: .medium, size: 20.0, relativeTo: .body)
                                        .foregroundColor(.black)
                                }
                            }

                            Spacer()
                            Spacer()
                                .navigationDestination(isPresented: $startChat) {
                                    ChatView(requestModel: $requestModel)
                                }
                        }
                        .padding()
                        .background(Constants.backgroundColor)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .statusBar(hidden: false)
                        .background(ignoresSafeAreaEdges: .all)
                    }
                    .padding(.bottom)
                }
            }
            .onAppear() {
                /*Task {
                    await sendChat(chatPayload: requestModel) { success, message in
                        if success {
                            promptText = message ?? ""
                            isLoading = false
                        }
                    }
                } */
            }
            .navigationBarBackButtonHidden(true)
}

    func sendChat(chatPayload: Chat.Request, completion: @escaping (Bool, String?) -> Void) async {
        do {
            // Create the URL
            guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
                completion(false, "Invalid URL.")
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
            print("first Request \(chatPayload)")
            // Create the request
            print("First Request \(jsonData)")
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
                completion(false, "Fetch Chat failed. Please try again.")
                return
              }

            let chatResponse = try JSONDecoder().decode(Chat.Response.self, from: data)
            let choices = chatResponse.choices
            let message = choices?[0].message
            let role = message?.role ?? ""
            let content = message?.content ?? ""
            let responseMessage = Chat.Request.MessageModel(role: role, content: content)
            requestModel.messages.append(responseMessage)
            print("first Response \(responseMessage)")
            completion(true, content)
            isLoading = false
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct FirstTabView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FirstTabViewModel()
        FirstTabView(viewModel: viewModel)
    }
}

extension FirstTabView {
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
        .background(Constants.backgroundColor)
    }

    private var menuButton: some View {
        Button { } label: {
            Image("dots")
                .resizable()
                .frame(width: 20, height: 5)
        }
    }

    private var joyceLogo: some View {
        Button { } label: {
            Image("headerlogo")
                .resizable()
                .frame(width: 165, height: 40)
        }
    }
}
