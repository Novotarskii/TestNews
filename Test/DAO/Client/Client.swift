
import Foundation
import Alamofire

protocol ClientProtocol: class{
    func didCompleteRequest(action: UInt16, object: Any)
    func didErrorRequest(action: UInt16, errorCode: Error)
    
    func didConnect()
    func didDisconnect()
}

class Client {
    static let shared: Client = Client()
    
    private let network: NetworkManager = NetworkManager.shared
    
    private var messageDelegates = Dictionary<String, ClientProtocol>()
    var connected: Bool = false
    
    init() {
        isConnected()
    }
    
    func addDelegate(key: String, delegate: ClientProtocol) {
        messageDelegates[key] = delegate
    }
    
    func removeDelegate(key: String) {
        messageDelegates.removeValue(forKey: key)
    }
    
    private func broadcastCompleteRequest(action: UInt16, object: Any) {
        for (_, val) in messageDelegates {
            val.didCompleteRequest(action: action, object: object)
        }
    }
    private func broadcastErrorRequest(action: UInt16, errorCode: Error) {
        for (_, val) in messageDelegates {
            val.didErrorRequest(action: action, errorCode: errorCode)
        }
    }
    private func broadcastDidConnect() {
        for (_, val) in messageDelegates {
            val.didConnect()
        }
    }
    
    private func broadcastDidDisconnect() {
        for (_, val) in messageDelegates {
            val.didDisconnect()
        }
    }
    
    func isConnected(){
        network.isReachable(completed: {
            [weak self] _ in
            self?.connected = true
            self?.broadcastDidConnect()
        })
        
        network.isUnreachable(completed: {
            [weak self] _ in
            self?.connected = false
            self?.broadcastDidDisconnect()
        })
    }
    
    func getPage(url: URL) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request)
            .responseJSON { [weak self] response in
                switch response.result {
                case .failure(let error):
                    self?.broadcastErrorRequest(action: ResponseType.getPage.rawValue, errorCode: error)
                case .success(let responseObject):
                    self?.broadcastCompleteRequest(action: ResponseType.getPage.rawValue, object: responseObject)
                }
        }
    }
}
