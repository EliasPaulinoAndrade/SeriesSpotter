import Foundation
@testable import SerieSpotter

final class SeriesListingServicingMock: SeriesListingServicing {
    var expectedReturn: Result<[Serie], Error> = .failure(RequestError.noResponse)
    private(set) var receivedPages: [Int] = []
    
    func fetchSeries(at page: Int) async throws -> [Serie] {
        receivedPages.append(page)
        
        switch expectedReturn {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}
