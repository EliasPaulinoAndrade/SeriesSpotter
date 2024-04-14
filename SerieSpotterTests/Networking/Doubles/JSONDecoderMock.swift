import Foundation
@testable import SerieSpotter

final class JSONDecoderMock: JSONDecoding {
    var expectedReturn: Result<Decodable, DecodingError> = .failure(.dataCorrupted(.init(codingPath: [], debugDescription: "")))
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        switch expectedReturn {
        case .success(let success):
            guard let success = success as? T else {
                throw AssertionError.wrongExpectedType
            }
            return success
        case .failure(let failure):
            throw failure
        }
    }
}

fileprivate enum AssertionError: Error {
    case wrongExpectedType
}

