import Foundation
import SwiftUI
import Swarm

@main
struct SwarmApp: App {
    
    static let store = Store()
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    #elseif os(iOS) || os(tvOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    #endif
    
    @Environment(\.scenePhase)
    private var phase
    
    @StateObject
    var store: Store
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .onChange(of: phase) {
            phaseChanged($0)
        }
        
        #if os(macOS)
        Settings {
            PreferencesView()
                .environmentObject(store)
        }
        #endif
    }
    
    init() {
        let store = SwarmApp.store
        _store = .init(wrappedValue: store)
        store.log("Launching Swarm v\(Bundle.InfoPlist.shortVersion) (\(Bundle.InfoPlist.version))")
    }
}

private extension SwarmApp {
    
    func phaseChanged(_ newValue: ScenePhase) {
        switch newValue {
        case .background:
            break
        case .inactive:
            break
        case .active:
            Task {
                await store.sendUsernameToWatch()
            }
        default:
            break
        }
    }
}

// MARK: - AppDelegate

#if os(iOS) || os(tvOS)
@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    
    let appLaunch = Date()
    
    private(set) var didBecomeActive: Bool = false
    
    var store: Store!
    
    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
                
        #if DEBUG
        defer { store?.log("App finished launching in \(String(format: "%.3f", Date().timeIntervalSince(appLaunch)))s") }
        #endif
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        store.log("Will resign active")
    }
}

#elseif os(macOS)
@MainActor
final class AppDelegate: NSResponder, NSApplicationDelegate {
    
    static var shared: AppDelegate { NSApplication.shared.delegate as! AppDelegate }
    
    var store: Store!
    
    // MARK: - NSApplicationDelegate
        
    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        return false
    }
}
#endif
