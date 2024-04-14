import Foundation
@testable import SerieSpotter

final class SeriesSearchingServicingMock: SeriesSearchingServicing {
    var expectedReturn: Result<[Serie], Error> = .failure(RequestError.noResponse)
    
    func searchSeries(query: String) async throws -> [Serie] {
        switch expectedReturn {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}
