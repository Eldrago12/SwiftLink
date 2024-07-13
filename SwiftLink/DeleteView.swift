//
//  DeleteView.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 11/07/24.
//


import SwiftUI

struct DeleteView: View {
    @State private var items: [Item] = []
    @State private var selectedItemId: String?
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    let maxOriginalUrlLength = 50

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            List(items) { item in
                HStack {
                    Toggle(isOn: Binding(
                        get: { self.selectedItemId == item.id },
                        set: { isSelected in
                            self.selectedItemId = isSelected ? item.id : nil
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text("ID: \(item.id)")
                                .font(.subheadline)
                            Text("Shortcode: \(item.shortcode)")
                                .font(.subheadline)
//                            Text("Original URL: \(item.originalUrl)")
//                                .font(.subheadline)
                            if item.originalUrl.count > maxOriginalUrlLength {
                                Text("Original URL: \(item.originalUrl.prefix(maxOriginalUrlLength))...")
                            } else {
                                Text("Original URL: \(item.originalUrl)")
                            }
                            
                            Text("Clicks: \(item.clicks)")
                                .font(.subheadline)
                            Text("Created At: \(item.createdAt)")
                                .font(.subheadline)
                            Link(destination: URL(string: item.shortUrl)!) {
                                Text("\(item.shortUrl)")
                                    .foregroundColor(.blue)
                            }
                        }
                        .modifier(GlassEffect())
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .background(self.selectedItemId == item.id ? Color.blue.opacity(0.3) : Color.clear)
                    .animation(.easeInOut, value: self.selectedItemId)
                }
            }
            .onAppear {
                Task {
                    do {
                        self.items = try await NetworkManager.shared.getUrl()
                    } catch {
                        self.errorMessage = "Failed to load items."
                    }
                }
            }

            Button(action: {
                guard let selectedItemId = selectedItemId else {
                    self.errorMessage = "No item selected."
                    return
                }

                Task {
                    do {
                        let responseMessage = try await NetworkManager.shared.deleteUrl(id: selectedItemId)
                        self.successMessage = responseMessage
                        self.items.removeAll { $0.id == selectedItemId }
                        self.selectedItemId = nil
                        self.errorMessage = nil
                    } catch {
                        self.errorMessage = "Failed to delete item."
                    }
                }
            }) {
                Text("Delete Selected Item")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Delete Items")
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .foregroundColor(configuration.isOn ? .blue : .primary)
                .imageScale(.large)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}



struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView()
    }
}
