import Foundation

protocol SeriesSearchingServicing {
    func searchSeries(query: String) async throws -> [Serie]
}

struct SeriesSearchingService {
    let requester: Requester<[SeriesDTO.SearchResult]>
}

extension SeriesSearchingService: SeriesSearchingServicing {
    func searchSeries(query: String) async throws -> [Serie] {
        let target = SearchSeriesApi(query: query)
        let searchDTO = try await requester.request(target: target)
        let series = SerieDTOMapper.getSeries(from: searchDTO.map { $0.show })
        return series
    }
}
