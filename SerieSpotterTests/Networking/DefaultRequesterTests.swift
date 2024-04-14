import XCTest
@testable import SerieSpotter

final class DefaultRequesterTests: XCTestCase {
    func testRequest_WhenHasWrongTarget_ShouldThrowWrongTarget() async throws {
        let (sut, _) = createSUT(forResultType: String.self)
        let targetStub = TargetMock(baseUrl: "bla.com", path: "path")
    
        try await XCTAssert(
            try await sut.request(target: targetStub),
            shouldThrow: RequestError.wrongTarget
        )
    }
    
    func testRequest_WhenURLSessionThrowsError_ShouldThrowBadRequest() async throws {
        let (sut, doubles) = createSUT(forResultType: String.self)
        let targetStub = TargetMock()
        let requestErrorStub = MockError()
        
        doubles.urlSessionMock.expectedReturn = .failure(requestErrorStub)
        
        try await XCTAssert(
            try await sut.request(target: targetStub),
            shouldThrow: RequestError.badRequest(requestErrorStub)
        )
    }
    
    func testRequest_WhenResponseIsNotHTTP_ShouldThrowBadRequest() async throws {
        let (sut, doubles) = createSUT(forResultType: String.self)
        let targetStub = TargetMock()
        
        doubles.urlSessionMock.expectedReturn = .success((Data(), URLResponse()))
        
        try await XCTAssert(
            try await sut.request(target: targetStub),
            shouldThrow: RequestError.noResponse
        )
    }
    
    func testRequest_WhenHasErrorStatus_ShouldThrowStatusError() async throws {
        let (sut, doubles) = createSUT(forResultType: String.self)
        let targetStub = TargetMock()
        let responseUrlStub = try XCTUnwrap(
            URL(string: "www.url.com")
        )
        let responseStub = try XCTUnwrap(
            HTTPURLResponse(url: responseUrlStub, statusCode: 404, httpVersion: nil, headerFields: nil)
        )
        
        doubles.urlSessionMock.expectedReturn = .success((Data(), responseStub))
        
        try await XCTAssert(
            try await sut.request(target: targetStub),
            shouldThrow: RequestError.statusError(404)
        )
    }
    
    func testRequest_WhenDecoderThrowError_ShouldThrowDataError() async throws {
        let (sut, doubles) = createSUT(forResultType: String.self)
        let targetStub = TargetMock()
        let responseUrlStub = try XCTUnwrap(
            URL(string: "www.url.com")
        )
        let responseStub = try XCTUnwrap(
            HTTPURLResponse(url: responseUrlStub, statusCode: 200, httpVersion: nil, headerFields: nil)
        )
        let decodeErrorStub = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
        
        doubles.urlSessionMock.expectedReturn = .success((Data(), responseStub))
        doubles.jsonDecoderMock.expectedReturn = .failure(decodeErrorStub)
        
        try await XCTAssert(
            try await sut.request(target: targetStub),
            shouldThrow: RequestError.badData(decodeErrorStub)
        )
    }
    
    func testRequest_WhenReponseAndDataAreCorrect_ShouldReturnResult() async throws {
        let (sut, doubles) = createSUT(forResultType: String.self)
        let targetStub = TargetMock()
        let responseUrlStub = try XCTUnwrap(
            URL(string: "www.url.com")
        )
        let responseStub = try XCTUnwrap(
            HTTPURLResponse(url: responseUrlStub, statusCode: 200, httpVersion: nil, headerFields: nil)
        )
        let requestResultStub = "result string"
        
        doubles.urlSessionMock.expectedReturn = .success((Data(), responseStub))
        doubles.jsonDecoderMock.expectedReturn = .success(requestResultStub)
        
        let requestResult = try await sut.request(target: targetStub)
        
        XCTAssertEqual(requestResult, requestResultStub)
    }
}

private extension DefaultRequesterTests {
    typealias Doubles = (
        urlSessionMock: URLSessionMock,
        jsonDecoderMock: JSONDecoderMock
    )

    func createSUT<ResultType>(forResultType: ResultType.Type) -> (DefaultRequester<ResultType>, Doubles) {
        let urlSessionMock = URLSessionMock()
        let jsonDecoderMock = JSONDecoderMock()
        let sut = DefaultRequester<ResultType>(
            urlSession: urlSessionMock,
            jsonDecoder: jsonDecoderMock
        )
        
        return (sut, (urlSessionMock, jsonDecoderMock))
    }
}
