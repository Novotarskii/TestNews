
import Foundation

protocol NewsToolBarProtocol: class {
    func didConnect()
    func didDisconnect()
    func didError(error: String)
}

class NewsToolBarModel {
    private let client: Client = Client.shared
    
    var delegate: NewsToolBarProtocol?
    
    init() {
        client.addDelegate(key: "NewsToolBarModel", delegate: self)
    }
    
    func removeDelegate() {
        client.removeDelegate(key: "NewsToolBarModel")
    }
    
    func checkInternetConnection() {
        if client.connected {
            delegate?.didConnect()
        } else {
            delegate?.didDisconnect()
        }
    }
}

extension NewsToolBarModel: ClientProtocol {
    func didCompleteRequest(action: UInt16, object: Any) {
        //Nothing
    }
    
    func didErrorRequest(action: UInt16, errorCode: Error) {
        delegate?.didError(error: errorCode.localizedDescription)
    }
    
    func didConnect() {
        delegate?.didConnect()
    }
    
    func didDisconnect() {
        delegate?.didDisconnect()
    }
}
