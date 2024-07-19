//
//  Message.swift
//  JoyceAI
//
//  Created by C119142 on 5/24/24.
//

import Foundation

public enum SendEmail {
    public struct Request: Codable {
    }
}

public enum Chat {
    public struct Request: Codable {
        public var model: String
        public var temperature: Float
        public var messages: [MessageModel]
        public struct MessageModel: Codable, Identifiable {
            public var id = UUID()
            public var role: String
            public var content: String
        }
    }

    public struct Response: Codable {
        public let id: String?
        public let object: String?
        public let created: Int?
        public var choices: [Choices]?
        public let usage: Usage?

        enum CodingKeys: String, CodingKey {
            case id
            case object
            case created
            case choices
            case usage
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(String.self, forKey: .id)
            object = try values.decodeIfPresent(String.self, forKey: .object)
            created = try values.decodeIfPresent(Int.self, forKey: .created)
            choices = try values.decodeIfPresent([Choices].self, forKey: .choices)
            usage = try values.decodeIfPresent(Usage.self, forKey: .usage)
        }
    }

    public struct Choices: Codable, Identifiable {
        public var id = UUID()
        public var message: Message?
        public let finishReason: String?

        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            message = try values.decodeIfPresent(Message.self, forKey: .message)
            finishReason = try values.decodeIfPresent(String.self, forKey: .finishReason)
        }
    }

    public struct Usage: Codable {
        public let promptTokens: Int?
        public let completionTokens: Int?
        public let totalTokens: Int?
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            promptTokens = try values.decodeIfPresent(Int.self, forKey: .promptTokens)
            completionTokens = try values.decodeIfPresent(Int.self, forKey: .completionTokens)
            totalTokens = try values.decodeIfPresent(Int.self, forKey: .totalTokens)
        }
    }

    public struct Message: Codable {
        public var role: String?
        public var content: String?

        enum CodingKeys: String, CodingKey {
            case role
            case content
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            role = try values.decodeIfPresent(String.self, forKey: .role)
            content = try values.decodeIfPresent(String.self, forKey: .content)
        }
    }
}

