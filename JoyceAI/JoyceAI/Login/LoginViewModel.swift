//
//  LoginViewModel.swift
//  JoyceAI
//
//  Created by C119142 on 5/25/24.
//
import AuthenticationServices
import Foundation

class LoginViewModel: ObservableObject {
    @Published var text: String = "First Tab"
    @Published var greetingText = "Hi Julia!"
    @Published var promptText = "What can i help you with?"
    @Published var fetchedData = false
    
    func sendChat(chatText: String, completion: @escaping (Bool, String?) -> Void) async {
        do {
            // Create the URL
            guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
                completion(false, "Invalid URL.")
                return
            }

            // Create the request body
            
            let payload: [String: Any] = [
                "model": "gpt-3.5-turbo-0125",
                "messages": [
                    ["role": "system", "content": "You are a helpful assistant."],
                    ["role": "user", "content": "Hello!"]
                ]
            ]

            // Convert the body to JSON data
            guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
                completion(false, "Invalid request body.")
                return
            }

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
                completion(false, "Fetch Chat failed. Please try again.")
                return
              }

            let chatResponse = try JSONDecoder().decode(Chat.Response.self, from: data)
            let choices = chatResponse.choices
            let message = choices?[0].message
            let content = message?.content
            promptText = content ?? ""
            fetchedData = true
            completion(true, content)

        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    // Add business logic and data fetching methods here
}
