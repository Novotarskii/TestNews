import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum sectionType: String {
    case top = "topNews"
    case other = "news"
}

enum NewsSectionItem {
    case topNews(items: [PageItemObjectModel])
    case news(item: PageItemObjectModel)
}

enum NewsSectionsModel {
    case topNewsSection(title: String, items: [NewsSectionItem])
    case newsSection(title: String, items: [NewsSectionItem])
}

extension NewsSectionsModel: SectionModelType {
    typealias Item = NewsSectionItem
    
    var items: [NewsSectionItem] {
        switch self {
        case .topNewsSection(title: _, items: let items):
            return items.map { $0 }
        case .newsSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: NewsSectionsModel, items: [Item]) {
        switch original {
        case let .topNewsSection(title: title, items: _):
            self = .topNewsSection(title: title, items: items)
        case let .newsSection(title, _):
            self = .newsSection(title: title, items: items)
        }
    }
}

extension NewsSectionsModel {
    var title: String {
        switch self {
        case .topNewsSection(title: let title, items: _):
            return title
        case .newsSection(title: let title, items: _):
            return title
        }
    }
}

fileprivate let sectionHeightTopNews: CGFloat = 250
fileprivate let sectionHeightNewsWithImage: CGFloat = 360
fileprivate let sectionHeightNewsWithuotImage: CGFloat = 160

class NewsViewModel {
    private var model: NewsModel?
    
    var sections = BehaviorRelay<[NewsSectionsModel]>(value: [])
    
    init() {
        model = NewsModel()
        model?.delegate = self
        model?.getNews()
        model?.page = URL(string: "")
    }
    
    deinit {
        model?.removeDelegate()
    }
    
    func getCellHeight(ip: IndexPath) -> CGFloat {
        switch sections.value[ip.section].items[0] {
        case let .news(item):
        if let _ = item.image?.url {
            return sectionHeightNewsWithImage
        } else {
            return sectionHeightNewsWithuotImage
        }
        case .topNews(_):
            return sectionHeightTopNews
        }
    }
    
    func getNewPageIfNeeded(ip: IndexPath) { // Якщо пролистано половино новин, потрібно завантажити наступну сторінку
        if ip.section == (sections.value.count / 2) {
            model?.getNews()
        }
    }
    
    func isLastSection(section: Int) -> Bool{
        if !(model?.isPage() ?? false) {return false}
        return (sections.value.count - 1) == section
    }
}

extension NewsViewModel: NewsProtocol {
    func setNews(news: [PageItemObjectModel], top: Bool) {
        var sectns = sections.value
        if top {
            let section: NewsSectionsModel = .topNewsSection(title: "topNews", items: [.topNews(items: news)])
            sectns.append(section)
            self.sections.accept(sectns)
        } else {
            for item in news {
                let section: NewsSectionsModel = .newsSection(title: "news", items: [.news(item: item)]) // В кожній секції по одному елементу
                sectns.append(section)
                self.sections.accept(sectns)
            }
        }
    }
    
    func didConnect() {
        sections.accept([])
    }
}


