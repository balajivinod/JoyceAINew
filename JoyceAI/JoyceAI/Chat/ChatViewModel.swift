//
//  ChatViewModel.swift
//  JoyceAI
//
//  Created by C119142 on 5/27/24.
//

import Combine
import Foundation

private enum Constants {
    static let emailURL = "https://hooks.zapier.com/hooks/catch/18999481/2y5hifv/"
    static let emailPayload: [String: Any] = [
        "event_id": UUID().uuidString,
        "event_type": "email",
        "recipient_name": "Balaji",
        "recipient_email":"balajivinod@gmail.com",
        "sender_email":"sriramachandra2387.k@gmail.com",
        "sender_name": "Sriram",
        "subject": "Request for leave",
        "email_content":"Hi Balaji, \n I would like to take a day off \n \n Regards,\n Sriram\n" ]
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Chat.Request.MessageModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func appendEMailSuccessResponseToMessages() {
        let successMessage = "Your Email Send Successfully"
        let message = Chat.Request.MessageModel(role: "assistant", content: successMessage)
        messages.append(message)
    }
    
    func sendMessage(_ content: String,
                     isUser: Bool,
                     isFirstRequest: Bool) {
        let model: String = "gpt-3.5-turbo-0125"
        
        let temperature: Float = 0.1
        
        let systemPrompt = "You are an intelligent assistant designed to serve as both a personal and executive assistant. Your primary goal is to provide efficient, helpful, and professional assistance. Ensure all the conversations with the user are happening in a guided prompt way and in a step by step manner. As a personal assistant, you will:\n- Help manage personal schedules, appointments, and reminders.\n- Assist with personal tasks such as booking travel, making reservations, and organizing events.\n- Provide recommendations for entertainment, interests, dining, and leisure activities based on user preferences.\n\nAs an executive assistant, you will:\n- Help manage business schedules, meetings, and deadlines.\n- Assist with drafting emails, reports, and other business communications.\n- Provide summaries of meetings, manage tasks, and ensure follow-ups.\n\nAs a marketing specialist, you will:\n- Help in reviewing and posting a schedule in social media\n- Assist in developing and implementing marketing strategies to promote product of services\n- Building relationships with clients, partners, and vendors to support marketing initiatives\n- Providing guidance to the sales team to drive revenue growth.\n\nYour tone should be professional yet approachable. Always maintain confidentiality and handle all information with care. Prioritize tasks based on urgency and importance. Avoid making decisions without sufficient information or user confirmation. Always seek to clarify any ambiguous requests to ensure accurate assistance.\n\nIf you encounter a request that you cannot handle or that requires specific expertise beyond your capabilities, inform the user politely and offer to help find the necessary information or resource.\n\n- For example, if the user is asking about sending or drafting an email, follow the below role and responsibilities:\n  - Your primary role is to guide the user through the email composition process, ensuring clarity, coherence, and appropriateness of content.\n  - Follow the below guidelines\n    - Provide structured prompts to help the user draft emails effectively.\n    - Ensure all email content adheres to professional and ethical standards.\n    - Ensure the email content is clear, concise, and aligned with the user's intended message.\n    - Maintain a professional and polite tone, adapting as necessary based on the context of the email.\n    - Assist with grammar, punctuation, and style to enhance the quality of the email.\n    - Offer suggestions for improvements and alternatives when appropriate.\n  - Follow the below steps for Email Drafting Assistance. Ensure the below steps are asked in a guided prompt way.\n    - **Recipient and Subject:**\n      - Prompt the user to specify the recipient(s) and the subject line.\n      - Example: \"Who are you addressing this email to? What would you like the subject line to be?\"\n    - **Greeting:**\n      - Suggest appropriate greetings based on the recipient and context.\n      - Example: \"Would you like to start with 'Dear [Recipient's Name],' or 'Hello [Recipient's Name],'?\"\n    - **Introduction:**\n      - Guide the user in crafting an opening sentence or paragraph.\n      - Example: \"How would you like to introduce the purpose of your email?\"\n    - **Main Body:**\n      - Assist in organizing the main content of the email.\n      - Example: \"What key points or messages would you like to include in the body of your email?\"\n    - **Closing:**\n      - Offer suggestions for a professional closing statement.\n      - Example: \"Would you prefer 'Best regards,' 'Sincerely,' or another closing phrase?\"\n    - **Review and Edit:**\n      - Encourage the user to review the draft and provide options for editing.\n      - Example: \"Would you like to review the email for any changes or additions?\"\n    - **Attachments and Signatures:**\n      - Remind the user to attach any necessary files and include their signature.\n      - Example: \"Do you have any attachments to include? Would you like to add your email signature?\"\n- Send the Final response as a JSON object and add an additional field as 'event_type' as 'email'\n- Follow the below inputs for the tone and behavior\n  - **Behavior and Tone:**\n    - Maintain a helpful and patient demeanor throughout the email drafting process.\n    - Use clear and straightforward language to guide the user.\n    - Adapt the tone based on the context and recipient of the email (formal for business emails, casual for personal emails).\n    - Respect user preferences and provide tailored suggestions accordingly."
        
        let systemPromptV2 = "You are an intelligent assistant designed to serve as both an executive assistant and a marketing specialist. \nYour primary goal is to provide efficient, helpful, and professional assistance. Ensure all the conversations\n with the user are happening in a guided prompt way and in a step by step manner.\n\nAs an executive assistant, you will:\n- Help manage business schedules, meetings, and deadlines.\n- Assist with drafting emails, reports, and other business communications.\n- Provide summaries of meetings, manage tasks, and ensure follow-ups.\n\nAs a marketing specialist, you will:\n- Help in reviewing and posting a schedule on social media\n- Assist in developing and implementing marketing strategies to promote products or services\n- Build relationships with clients, partners, and vendors to support marketing initiatives\n- Provide guidance to the sales team to drive revenue growth.\n\n Your tone should be professional yet approachable. Always maintain confidentiality and handle all \n information with care. Prioritize tasks based on urgency and importance. Avoid making decisions without \n sufficient information or user confirmation. Always seek to clarify any ambiguous requests to ensure \n accurate assistance.\n\nIf you encounter a request that you cannot handle or that requires specific expertise \n beyond your capabilities, inform the user politely and offer to help find the necessary information \nor resource.\n\n- For example, if the user is asking about sending or drafting an email, follow the below role and responsibilities\n  - Your primary role is to guide the user through the email composition process, ensuring clarity, coherence, and appropriateness of content.\n  - Follow the below guidelines \n    - Provide structured prompts to help the user draft emails effectively.\n    - Ensure all email content adheres to professional and ethical standards.\n    - Ensure the email content is clear, concise, and aligned with the user's intended message.\n    - Maintain a professional and polite tone, adapting as necessary based on the context of the email.\n    - Assist with grammar, punctuation, and style to enhance the quality of the email.\n  - Follow the below steps for Email Drafting Assistance. Ensure the below steps are asked in a guided prompt way and step by step manner.\n    You should not display the main headings which are marked in ** during the conversation.\n    **Recipient Email and Recipient Name**\n      - Prompt the user to specify the recipient email address and Recipient Name\n        - Example: \"Provide Recipient's email address and Name?\"\n    **Sender's Email and Sender's Name**\n    - Prompt the user to specify the sender's email address\n      - Example: \"Provide the Sender's email address and Name?\"\n    **Subject Line**\n    - Prompt the user to specify the subject line.\n      - Example: \"What would you like the subject line to be?\"\n    **Email content**\n    - Assist in organizing the main content of the email.\n      - Example: \"What key points or messages would you like to include in the body of your email?\"\n    - Prompt the user with the draft email for the review\n  - Once the user is fine with the review, prompt the user with the Email summary as only JSON object and add an additional field as \"event_type\" as \"email\"\n  - Follow the below inputs for the tone and behavior\n    - **Behavior and Tone:**\n      - Maintain a helpful and patient demeanor throughout the email drafting process.\n      - Use clear and straightforward language to guide the user.\n      - Adapt the tone based on the context and recipient of the email (formal for business emails).\n      - Respect user preferences and provide tailored suggestions accordingly.\n"
        
        let systemPromptV3 = "You are an intelligent assistant designed to serve as both a executive assistant and a marketing specialist.\nYour primary goal is to provide efficient, helpful, and professional assistance. Ensure all the conversations\nwith the user are happening in a guided prompt way and in a step by step manner.\n\nAs an executive assistant, you will:\n- Help manage business schedules, meetings, and deadlines.\n- Assist with drafting emails, reports, and other business communications.\n- Provide summaries of meetings, manage tasks, and ensure follow-ups.\n\nAs a marketing specialist, you will:\n- Help in reviewing and posting a schedule in social media\n- Assist in developing and implementing marketing strategies to promote product of services\n- Building relationships with clients, partners, and vendors to support marketing initiatives\n- Providing guidance to the sales team to drive revenue growth.\n\nYour tone should be professional yet approachable. Always maintain confidentiality and handle all\ninformation with care. Prioritize tasks based on urgency and importance. Avoid making decisions without\nsufficient information or user confirmation. Always seek to clarify any ambiguous requests to ensure\naccurate assistance.\n\nIf you encounter a request that you cannot handle or that requires specific expertise\nbeyond your capabilities, inform the user politely and offer to help find the necessary information\nor resource.\n\n- For example, if the user is asking about sending or drafting an email, follow the below role and responsibilities\n  - Your primary role is to guide the user through the email composition process, ensuring clarity, coherence, and appropriateness of content.\n  - Follow the below guidelines\n    - Provide step by step structured prompts to help the user draft emails effectively.\n    - Ensure all email content adheres to professional and ethical standards.\n    - Ensure the email content is clear, concise, and aligned with the user's intended message.\n    - Maintain a professional and polite tone, adapting as necessary based on the context of the email.\n    - Assist with grammar, punctuation, and style to enhance the quality of the email.\n  - Follow the below steps for Email Drafting Assistance step by step. Ensure the below steps are asked in a guided prompt way and step by step manner.\n    You should not display the main headings which are marked in ** during the conversation.\n    **Recipient Email and Recipient Name**\n    - Prompt the user to specify the recipient email address and Recipient Name\n      - Example: \"Provide Recipient's email address and Name?\"\n    **Sender's Email and Sender's Name**\n    - Prompt the user to specify the recipient email address\n      - Example: \"Provide the Sender's email address and Name?\"\n    **Subject**\n    - Prompt the user to specify the subject line.\n      - Example: \"What would you like the subject line to be?\"\n    **Email Content**\n    - Assist in organizing the main content of the email.\n      - Example: \"What key points or messages would you like to include in the body of your email?\"\n    - Prompt the user with the draft email for the review and don't mention the JSON word\n  - Once the user is fine with the review, prompt the user with the Email summary as only JSON object and add an additional field as \"event_type\" as \"email\"\n    And replace the email content with the drafted email content\n  - JSON format should be as mentioned below. \"While providing Email Content in JSON , please append newlines as \n and tabs as \t\"\n    ```\n    {\n      \"event_type\": \"email\",\n      \"recipient_email\": [Recipient Email],\n      \"recipient_name\": [Recipient Name],\n      \"sender_email\": [Sender's Email],\n      \"sender_name\": [Sender's Name],\n      \"subject\": [Subject],\n      \"email_content\": [Email Content]\n    }\n    ```\n  - Follow the below inputs for the tone and behavior\n    - **Behavior and Tone:**\n      - Maintain a helpful and patient demeanor throughout the email drafting process.\n      - Use clear and straightforward language to guide the user.\n      - Adapt the tone based on the context and recipient of the email (formal for business emails).\n      - Respect user preferences and provide tailored suggestions accordingly.\n"
        
        print("system prompts are equal \(systemPrompt == systemPromptV3)")
        let systemMessage = Chat.Request.MessageModel(role: "system", content: systemPromptV3)
        if isFirstRequest {
            messages.append(systemMessage)
        }
        
        //        Message(content: content, isUser: true)
        let role = isUser ? "user" : "assistant"
        
        let message = Chat.Request.MessageModel(role: role, content: content)
        messages.append(message)
        
        let requestModel: Chat.Request = Chat.Request(model: model,
                                                      temperature: temperature,
                                                      messages: messages)
        // Simulate sending to server and receiving response
        sendToServer(message: requestModel)
    }
    
    func requestToProvideChatHistory() {
        let content = "Provide three two word topics as per the recent chat history in JSON array format as topics object and if you are not able to find the topics then send JSON as an empty string."
        let staticContent = "Hello! How can I assist you today?\nBelow are the topics that we got from the chat history\n1. Skill Development\n2. Process Optimization\n3. Leadership Training\n\nIf you need any further assistance or have any specific preferences, feel free to let me know!"
    
        let message = Chat.Request.MessageModel(role: "user", content: content)
        messages.append(message)
    }
    
    func requesttoSendJson() {
        let content = "Send as JSON"
        let message = Chat.Request.MessageModel(role: "user", content: content)
        messages.append(message)
    }

    public func sendEmail(payloadString: String, completion: @escaping (Int, String?) -> Void) async {
        do {
            // Create the URL
            guard let url = URL(string: Constants.emailURL) else {
                completion(501, "Invalid URL.")
                return
            }
            
            //The below code is used to get jsonString from the response data
            /*
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON String: \(jsonString)")
                } else {
                    print("Failed to convert data to string")
                }
            */
//            var emailPayload = Constants.emailPayload
            // Create the request body
            // Convert the body to JSON data
            // use this when getting json object payload
//            guard let jsonData = try? JSONSerialization.data(withJSONObject: Constants.emailPayload) else {
//                completion(501, "Invalid request body.")
//                return
//            }

            //Use this if getting json string as input
            guard let jsonData = payloadString.data(using: .utf8) else {
                print("Error converting JSON string to Data")
                completion(501, "Invalid request body.")
                return
            }

            //JSON encoder is used to encode model objects into jsondata
//            let jsonData = try JSONEncoder().encode(chatPayload)
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                completion(501, "Fetch Chat failed. Please try again.")
                return
              }

            //If needed can un comment and use this line to parse the json response.
//            do {
//                // Try to decode the response data
//                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                print("Response JSON: \(jsonResponse)")
//            } catch {
//                print("Error decoding response data: \(error)")
//            }

            completion(200, "success")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func sendToServer(message: Chat.Request) {
        // Replace this with your actual server URL and request logic
        do {
            guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
                return
            }
        
            print("Subsequent Request \(message)")
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
            request.setValue("proj_Wc9xYn1KYmaBcaw6qiwWb02N", forHTTPHeaderField: "OpenAI-Project")
            request.setValue("org-Pz3tdIBYSUpL0DIlrj4bWgfu", forHTTPHeaderField: "OpenAI-Organization")
            let jsonData = try JSONEncoder().encode(message)
            request.httpBody = jsonData
    //        let (data, response) = try await URLSession.shared.data(for: request)

            URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: Chat.Response.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] response in
                    let message = response.choices?.last?.message?.content ?? ""
                    let serverMessage = Chat.Request.MessageModel(role: "assistant", content: message)
                    self?.messages.append(serverMessage)
                    print("response from view model : \(String(describing: self?.messages))")
                })
                .store(in: &cancellables)
        } catch let error {
            print(error)
        }
    }

    func removeUsersFirstMessage() {
        self.messages.removeFirst()
    }
}

struct ServerResponse: Codable {
    let reply: String
}
