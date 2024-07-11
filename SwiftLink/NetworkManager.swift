//
//  NetworkManager.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 11/07/24.
//

import Foundation

struct UrlRequestBody: Codable {
    let originalUrl: String
}

struct UrlResponseBody: Codable {
    let shortUrl: String
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func createShortUrl(originalUrl: String) async throws -> String {
        guard let url = URL(string: "https://url.opsorbit.me/createurl") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = UrlRequestBody(originalUrl: originalUrl)
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
            let responseBody = try JSONDecoder().decode(UrlResponseBody.self, from: data)
            return responseBody.shortUrl
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
