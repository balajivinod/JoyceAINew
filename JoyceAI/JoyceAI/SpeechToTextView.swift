//
//  SwiftUIView.swift
//  JoyceAI
//
//  Created by C119142 on 6/20/24.
//

import SwiftUI

struct SpeechToTextView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()

    var body: some View {
        VStack {
            Text(speechRecognizer.transcript)
                .padding()

            if let audioFilePath = speechRecognizer.audioFilePath {
                Text("Recorded file: \(audioFilePath.lastPathComponent)")
                    .padding()

                Button(action: {
                    // Add functionality to share or view the file
                    shareAudioFile(url: audioFilePath)
                }) {
                    Text("Share Recorded File")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            HStack {
                Button(action: {
                    speechRecognizer.startRecording()
                }) {
                    Text("Start Recording")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    speechRecognizer.stopRecording()
                }) {
                    Text("Stop Recording")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
    }

    func shareAudioFile(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

#Preview {
    SpeechToTextView()
}
