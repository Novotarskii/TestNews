import Foundation

class TopNewsTableVIewCellViewModel {
    private var topNews: [PageItemObjectModel] = []
    
    func getTopNews() -> [PageItemObjectModel]{
        return topNews
    }
    
    func setTopNews(news: [PageItemObjectModel]) {
        self.topNews = news
    }
}
