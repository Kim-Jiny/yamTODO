import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import Firebase

@main
struct yamTODOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var selectedTab: Tabs = .home // 탭 상태 관리
    
    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab)
                .onAppear {
                    generateAndStoreUUID()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    ATTrackingManager.requestTrackingAuthorization { _ in }
                }
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        if url.scheme == "yamtodo" {
            print("Deep Link Received: \(url)")
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            // 쿼리 매개변수 확인
            if let widget = components?.queryItems?.first(where: { $0.name == "widget" })?.value,
               widget == "calendar" {
                DispatchQueue.main.async {
                    selectedTab = .calendar // 캘린더 탭으로 변경
                }
            }
            
            // 쿼리 매개변수 확인
            if let widget = components?.queryItems?.first(where: { $0.name == "widget" })?.value,
               widget == "home" {
                DispatchQueue.main.async {
                    selectedTab = .home // 캘린더 탭으로 변경
                }
            }
        }
    }
    
    private func generateAndStoreUUID() {
        let userDefaults = UserDefaults.standard
        let uuidKey = "userUUID"
        
        if userDefaults.string(forKey: uuidKey) == nil {
            let newUUID = UUID().uuidString
            userDefaults.set(newUUID, forKey: uuidKey)
            print("Generated new UUID: \(newUUID)")
        } else if let storedUUID = userDefaults.string(forKey: uuidKey) {
            print("Existing UUID: \(storedUUID)")
        }
    }
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}
