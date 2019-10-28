
import Foundation

struct PageObjectModel: Decodable {
    var next: String?
    var previous: String?
    var results: [PageItemObjectModel]?
    
    enum CodingKeys: String, CodingKey {
        case next
        case previous
        case results
    }
}

struct PageItemObjectModel: Decodable {
    var id: Int?
    var name: String?
    var image: PageImage?
    var price: Int?
    var priceWeek: Int?
    var priceMonth: Int?
    var currency: PageCurrency?
    var viewCount: Int?
    var favorite: Bool?
    var emailCount: Int?
    var phoneCount: Int?
    var owner: Bool?
    var category: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case price
        case priceWeek = "price_week"
        case priceMonth = "price_month"
        case currency
        case viewCount = "view_count"
        case favorite
        case emailCount = "email_count"
        case phoneCount = "phone_count"
        case owner
        case category
    }
}

struct PageImage: Decodable {
    var url: String?
    var width: Int?
    var height: Int?
    
    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
    }
}

struct PageCurrency: Decodable {
    var id: Int?
    var name: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
    }
}


