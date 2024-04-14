import XCTest

fileprivate enum AssertionError: Error {
    case errorNotThrew
}

func XCTAssert<T, E: Error&Equatable>( _ expression: @autoclosure () async throws -> T, shouldThrow expectedError: E) async throws {
    do {
        _ = try await expression()
        throw AssertionError.errorNotThrew
    } catch {
        guard let typedError = error as? E else {
            throw AssertionError.errorNotThrew
        }
        
        if typedError != expectedError {
            throw AssertionError.errorNotThrew
        }
    }
}
