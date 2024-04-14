import Foundation

struct SearchSeriesApi: RequestTarget {
    let query: String
    
    var path: String {
        return "/search/shows"
    }
    
    var queryItems: [URLQueryItem] {
        let pageItem = URLQueryItem(
            name: "q",
            value: query
        )

        return [pageItem]
    }
}
