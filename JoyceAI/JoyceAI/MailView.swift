//
//  MailView.swift
//  JoyceAI
//
//  Created by C119142 on 5/30/24.
//

import Foundation
import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    var recipients: [String]
    var subject: String
    var body: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                parent.presentation.wrappedValue.dismiss()
            }
            if let error = error {
                parent.result = .failure(error)
                return
            }
            parent.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = context.coordinator
            vc.setToRecipients(recipients)
            vc.setSubject(subject)
            vc.setMessageBody(body, isHTML: false)
            return vc
        } else {
            return UIViewController() // Return an empty view controller if mail services are not available
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
