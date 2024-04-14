import Foundation

protocol Requesting {
    associatedtype ResultType: Decodable
    func request(target: RequestTarget) async throws -> ResultType
}

extension Requesting {
    var asGeneric: Requester<ResultType> {
        .init(requester: self)
    }
}

struct Requester<ResultType: Decodable>: Requesting {
    private let requestClosure: (RequestTarget) async throws -> ResultType
    
    init<RequesterType: Requesting>(requester: RequesterType) where RequesterType.ResultType == ResultType {
        self.requestClosure = requester.request
    }
    
    public func request(target: RequestTarget) async throws -> ResultType {
        try await requestClosure(target)
    }
}
