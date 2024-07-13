import SwiftUI

struct ContentView: View {
    @State private var showSidebar = false
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack {
                    Spacer()
                    Text("Welcome to SwiftLink")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(isDarkMode ? .white : .black)

                    Text("Effortlessly shorten URLs for easy sharing.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(isDarkMode ? .white : .black)

                    Text("Quick, reliable, and secure URL shortening service.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(isDarkMode ? .white : .black)
                    Spacer()
                }
                .background(
                    // Background image
                    Image("backgroundImage")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
                .opacity(showSidebar ? 0.3 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: showSidebar)

                // Sidebar
                if showSidebar {
                    SidebarView(isDarkMode: $isDarkMode)
                        .transition(.move(edge: .leading))
                }

                // Sidebar toggle button
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .padding()
                                .foregroundColor(isDarkMode ? .white : .black)
                        }
                        Spacer()

                        // Dark/Light mode toggle button
                        Button(action: {
                            withAnimation {
                                isDarkMode.toggle()
                            }
                        }) {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                                .font(.title)
                                .padding()
                                .foregroundColor(isDarkMode ? .white : .black)
                        }
                    }
                    .padding(.top, 40) // Adjust this value to move the buttons lower
                    Spacer()
                }
            }
            .background(isDarkMode ? Color.black : Color.white)
            .edgesIgnoringSafeArea(.all)
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



