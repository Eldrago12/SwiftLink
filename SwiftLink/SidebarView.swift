//
//  SidebarView.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 11/07/24.
//

import SwiftUI

struct SidebarView: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Menu")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 90)
                        .padding(.leading, 20)
                        .foregroundColor(isDarkMode ? .white : .black)
                    Spacer()
                }
                NavigationLink(destination: CreateNewView()) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Create New")
                            .font(.headline)
                    }
                    .padding(.vertical, 10)
                    .padding(.leading, 30)
                    .foregroundColor(isDarkMode ? .white : .black)
                }
                NavigationLink(destination: PreviouslyCreatedView()) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("Previously Created")
                            .font(.headline)
                    }
                    .padding(.vertical, 10)
                    .padding(.leading, 30)
                    .foregroundColor(isDarkMode ? .white : .black)
                }
                NavigationLink(destination: DeleteView()) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                            .font(.headline)
                    }
                    .padding(.vertical, 10)
                    .padding(.leading, 30)
                    .foregroundColor(isDarkMode ? .white : .black)
                }
                Spacer()
            }
            .frame(width: 250)
            .background(isDarkMode ? Color.black : Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            Spacer()
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(isDarkMode: .constant(false))
    }
}

