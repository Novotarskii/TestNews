import Foundation

protocol NewsProtocol: class {
    func setNews(news: [PageItemObjectModel], top: Bool)
    func didConnect()
}

class NewsModel {
    private let client: Client = Client.shared
    private var news: [PageItemObjectModel] = []
    private var topNews: [PageItemObjectModel] = []
    
    weak var delegate: NewsProtocol?
    
    var page: URL?
    
    init() {
        client.addDelegate(key: "NewsModel", delegate: self)
        page = URL(string: Constants.newsFirstPage)!
    }
    
    func getNews() {
        if client.connected {
            guard let page = page else {
                return
            }
            
            client.getPage(url: page)
        }
    }
    
    private func setNews(object: Any) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject:object) else  {
            return
        }
        
        guard let page = try? JSONDecoder().decode(PageObjectModel.self, from: jsonData) else {
            return
        }
        
        if self.page == URL(string: page.next ?? "") { // Перевірка, щоб випадково сторінки не повоторювались
            return
        }
        
        self.page = URL(string: page.next ?? "")
        
        guard let items = page.results else {
            return
        }
        
        if let _ = page.previous { // Перша сторінка це завжди топ новини.
            self.news = items
            delegate?.setNews(news: self.news, top: false)
        } else {
            self.topNews += items
            delegate?.setNews(news: self.topNews, top: true)
        }
    }
    
    func isPage() -> Bool{
        return self.page != nil
    }
    
    func removeDelegate() {
        client.removeDelegate(key: "NewsModel")
    }
}

extension NewsModel: ClientProtocol {
    func didCompleteRequest(action: UInt16, object: Any) {
        switch action {
        case ResponseType.getPage.rawValue:
            setNews(object: object)
        default:
            break
        }
    }
    
    func didErrorRequest(action: UInt16, errorCode: Error) {
        //Nothing
    }
    
    func didConnect() {
        print("didConnect")
        news = []
        topNews = []
        delegate?.didConnect()
        page = URL(string: Constants.newsFirstPage)!
        getNews()
    }
    
    func didDisconnect() {
        //Nothing
    }
}
