import Foundation

struct AllSeriesApi: RequestTarget {
    let page: Int
    
    var path: String {
        return "/shows"
    }
    
    var queryItems: [URLQueryItem] {
        let pageItem = URLQueryItem(
            name: "page",
            value: String(page)
        )

        return [pageItem]
    }
}
