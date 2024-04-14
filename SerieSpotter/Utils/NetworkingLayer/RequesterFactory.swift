import Foundation

struct RequesterFactory {
    func makeRequester<T>() -> Requester<T> {
        DefaultRequester(urlSession: URLSession.shared, jsonDecoder: JSONDecoder())
            .asGeneric
    }
}
