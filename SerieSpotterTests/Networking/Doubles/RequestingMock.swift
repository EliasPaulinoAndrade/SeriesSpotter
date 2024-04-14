import Foundation
@testable import SerieSpotter

final class RequestingMock: Requesting {
    var expectedReturn: Result<String, Error> = .success("result")
    private(set) var requestInvocations: [RequestTarget] = []
    func request(target: RequestTarget) async throws -> String {
        requestInvocations.append(target)
        switch expectedReturn {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}
