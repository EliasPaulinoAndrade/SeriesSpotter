import Foundation

struct DefaultRequester<ResultType: Decodable>: Requesting {
    let urlSession: URLSessioning
    let jsonDecoder: JSONDecoding
    
    func request(target: RequestTarget) async throws -> ResultType {
        guard let urlRequest = URLRequest(target: target) else {
            throw RequestError.wrongTarget
        }
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            
            guard isReponseValid(httpResponse) else {
                throw RequestError.statusError(httpResponse.statusCode)
            }
            
            return try jsonDecoder.decode(ResultType.self, from: data)
        } catch let error as DecodingError {
            throw RequestError.badData(error)
        } catch let error as RequestError {
            throw error
        } catch {
            throw RequestError.badRequest(error)
        }
    }
}

private extension DefaultRequester {
    func isReponseValid(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
