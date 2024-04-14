import Foundation

protocol RequestTarget {
    var baseUrl: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension RequestTarget {
    var queryItems: [URLQueryItem] {
        []
    }
}

extension URLRequest {
    init?(target: RequestTarget) {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = target.baseUrl
        components.path = target.path
        components.queryItems = target.queryItems
    
        guard let url = components.url else {
            return nil
        }
        
        self = .init(url: url)
    }
}
