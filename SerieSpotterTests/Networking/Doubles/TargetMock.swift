import Foundation
@testable import SerieSpotter

struct TargetMock: RequestTarget, Equatable {
    let baseUrl: String
    let path: String
    
    init(baseUrl: String = "bla.com", path: String = "/path") {
        self.baseUrl = baseUrl
        self.path = path
    }
}
