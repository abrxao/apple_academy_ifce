import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "home"
    let tabs = ["home", "search", "notifications", "profile"]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabs, id: \.self) { tab in
                VStack {
                    Text(tab.capitalized)
                        .font(.title)
                        .padding()
                    Spacer()
                }
                .tag(tab)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            // Simulate changing the selectedTab based on the active page ID
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                selectedTab = "notifications" // Assuming the active page ID is "notifications"
            }
        }
        .tabItem {
            Image(systemName: "house")
            Text("Home")
        }
        .tag("home")
        
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
        .tag("search")
        
        .tabItem {
            Image(systemName: "bell")
                .foregroundColor(selectedTab == "notifications" ? .red : .black) // Highlight the notifications icon
            Text("Notifications")
        }
        .tag("notifications")
        
        .tabItem {
            Image(systemName: "person")
            Text("Profile")
        }
        .tag("profile")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
