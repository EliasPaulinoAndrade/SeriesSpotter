import Foundation

protocol SeriesListingServicing {
    func fetchSeries(at page: Int) async throws -> [Serie]
}

struct SeriesListingService {
    let requester: Requester<[SeriesDTO.Serie]>
}

extension SeriesListingService: SeriesListingServicing {
    func fetchSeries(at page: Int) async throws -> [Serie] {
        let target = AllSeriesApi(page: page)
        let seriesDTOs = try await requester.request(target: target)
        let series = SerieDTOMapper.getSeries(from: seriesDTOs)
        return series
    }
}
