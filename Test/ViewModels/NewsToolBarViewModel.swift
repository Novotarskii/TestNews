
import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class NewsToolBarViewModel {
    var internetConnection = BehaviorRelay(value: true)
    var error = BehaviorRelay<String>(value: "")
    
    private var model: NewsToolBarModel?
    
    init() {
        model = NewsToolBarModel()
        model?.delegate = self
        model?.checkInternetConnection()
    }
    
    deinit {
        model?.removeDelegate()
    }
}

extension NewsToolBarViewModel: NewsToolBarProtocol {
    func didConnect() {
        internetConnection.accept(true)
    }
    
    func didDisconnect() {
        internetConnection.accept(false)
    }
    
    func didError(error: String) {
        self.error.accept(error)
    }
}
