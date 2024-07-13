//
//  CreateNewView.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 11/07/24.
//

import SwiftUI

struct CreateNewView: View {
    
    @State private var textInput: String = ""
    @State private var shortUrl: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            TextField("Enter original URL", text: $textInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            
            Button(action: {
                Task {
                    await handleCreateShortUrl()
                }
            }) {
                Text("Create Short URL")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            
//            if !shortUrl.isEmpty {
//                Text("\(shortUrl)")
//                    .padding()
//            }
            if let url = URL(string: shortUrl), !shortUrl.isEmpty {
                Link("\(shortUrl)", destination: url)
                    .padding()
            } else if !shortUrl.isEmpty {
                Text("\(shortUrl)")
                    .padding()
            }
            
            
            if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            
        }
        .padding()
    }

    func handleCreateShortUrl() async {
        do {
            let shortUrl = try await NetworkManager.shared.createShortUrl(originalUrl: textInput)
            DispatchQueue.main.async {
                self.shortUrl = shortUrl
                self.errorMessage = ""
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Request failed: \(error.localizedDescription)"
            }
        }
    }
}


struct CreateNewView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewView()
    }
}
