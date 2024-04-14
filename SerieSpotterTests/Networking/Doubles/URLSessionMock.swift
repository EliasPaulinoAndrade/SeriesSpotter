import Foundation
@testable import SerieSpotter

final class URLSessionMock: URLSessioning {
    var expectedReturn: Result<(Data, URLResponse), MockError> = .failure(MockError())
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        switch expectedReturn {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}
