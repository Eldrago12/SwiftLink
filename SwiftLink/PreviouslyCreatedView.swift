//
//  PreviouslyCreatedView.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 11/07/24.
//

import SwiftUI

struct PreviouslyCreatedView: View {
    @State private var items: [Item] = []
    @State private var errorMessage: String = ""

    let maxOriginalUrlLength = 50
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    await fetchData()
                }
            }) {
                Text("Get Your URLs")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(items, id: \.id) { item in
                        VStack(alignment: .leading) {
                            
                            Text("ID: \(item.id)")
                            Text("Shortcode: \(item.shortcode)")
                            
                            if item.originalUrl.count > maxOriginalUrlLength {
                                Text("Original URL: \(item.originalUrl.prefix(maxOriginalUrlLength))...")
                            } else {
                                Text("Original URL: \(item.originalUrl)")
                            }
                            
                            Text("Clicks: \(item.clicks)")
                            Text("Created At: \(item.createdAt)")
                            
                            Link(destination: URL(string: item.shortUrl)!) {
                                Text("\(item.shortUrl)")
                                    .foregroundColor(.blue)
                            }
                        }
                        .modifier(GlassEffect())
                        .padding()
                    }
                }
            }
            
            if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Previously Created")
        .onAppear {
            // Optionally fetch data when view appears
            Task {
                await fetchData()
            }
        }
    }

    func fetchData() async {
        do {
            self.items = try await NetworkManager.shared.getUrl()
            self.errorMessage = ""
        } catch {
            self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
        }
    }
}

struct PreviouslyCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        PreviouslyCreatedView()
    }
}
