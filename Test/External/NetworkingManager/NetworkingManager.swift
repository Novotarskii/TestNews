import Foundation
import Reachability

class NetworkManager: NSObject {
    
    static let shared: NetworkManager = NetworkManager()
    
    private var reachability: Reachability!
    
    override init() {
        super.init()
    
        reachability = Reachability()!
        
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        Client.shared.isConnected()
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.shared.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection != .none {
            completed(NetworkManager.shared)
        }
    }
    
    // Network is unreachable
    func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection == .none {
            completed(NetworkManager.shared)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection == .cellular {
            completed(NetworkManager.shared)
        }
    }
    
    // Network is reachable via WiFi
    func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection == .wifi {
            completed(NetworkManager.shared)
        }
    }
}
