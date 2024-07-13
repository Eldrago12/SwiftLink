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

struct Item: Codable, Identifiable {
    let id: String
    let shortcode: String
    let originalUrl: String
    let clicks: Int
    let createdAt: String
    let shortUrl: String
}


struct SignUpRequest: Codable {
    let email: String
    let password: String
}

struct SignUpResponse: Codable {
    let success: Bool
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let idToken: String
    let refreshToken: String
    let expiresIn: String
}

struct DeleteResponse: Codable {
    let message: String
}


class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.opsorbit.me/"
    
    private init() {}
    
//    func createShortUrl(originalUrl: String) async throws -> String {
//        guard let url = URL(string: baseUrl + "createurl") else {
//            throw URLError(.badURL)
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body = UrlRequestBody(originalUrl: originalUrl)
//        let jsonData = try JSONEncoder().encode(body)
//        request.httpBody = jsonData
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
//            let responseBody = try JSONDecoder().decode(UrlResponseBody.self, from: data)
//            return responseBody.shortUrl
//        } else {
//            throw URLError(.badServerResponse)
//        }
//    }
    
    
    
    func createShortUrl(originalUrl: String) async throws -> String {
        guard let url = URL(string: baseUrl + "createurl") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Retrieve idToken from UserDefaults
        if let idToken = UserDefaults.standard.string(forKey: "idToken") {
            request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        } else {
            throw URLError(.userAuthenticationRequired)
        }
        
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
    
    
    
//    func getUrl() async throws -> [Item] {
//        guard let url = URL(string: baseUrl + "geturl") else {
//            throw URLError(.badURL)
//        }
//
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let items = try JSONDecoder().decode([Item].self, from: data)
//        return items
//    }
    
    
    
    func getUrl() async throws -> [Item] {
        guard let url = URL(string: baseUrl + "geturl") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Retrieve idToken from UserDefaults
        if let idToken = UserDefaults.standard.string(forKey: "idToken") {
            request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        } else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let items = try JSONDecoder().decode([Item].self, from: data)
            return items
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    
    
    func deleteUrl(id: String) async throws -> String {
        guard let url = URL(string: baseUrl + "deleteurl/\(id)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "idToken") ?? "")", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
            let responseBody = try JSONDecoder().decode(DeleteResponse.self, from: data)
            return responseBody.message
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    
    func signUp(email: String, password: String) async throws -> SignUpResponse {
        guard let url = URL(string: baseUrl + "signup") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SignUpRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(SignUpResponse.self, from: data)
    }
    
    
    func login(email: String, password: String) async throws {
        guard let url = URL(string: baseUrl + "login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(email: email, password: password)
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let responseBody = try JSONDecoder().decode(LoginResponse.self, from: data)
            UserDefaults.standard.set(responseBody.idToken, forKey: "idToken")
        } else {
            throw URLError(.userAuthenticationRequired)
        }
    }
}
