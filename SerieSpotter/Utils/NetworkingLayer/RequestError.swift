import Foundation

enum RequestError: Error, Equatable {
    case wrongTarget
    case noResponse
    case badRequest(Error)
    case badData(DecodingError)
    case statusError(Int)
    
    public static func ==(lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case (.wrongTarget, .wrongTarget), (.noResponse, .noResponse):
            return true
        case let (.badRequest(error1), .badRequest(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.badData(decodingError1), .badData(decodingError2)):
            return decodingError1.localizedDescription == decodingError2.localizedDescription
        case let (.statusError(code1), .statusError(code2)):
            return code1 == code2
        default:
            return false
        }
    }
}
