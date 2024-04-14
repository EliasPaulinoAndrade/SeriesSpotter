import Foundation

actor SeriesListingState {
    private var lastFetchedPage: Int? = nil
    private var fetchedSeries: [Serie] = []
    
    var hasLoadedPage: Bool {
        lastFetchedPage != nil
    }
    
    func cleanFetchedSeries() {
        fetchedSeries = []
    }
    
    func incrementFetchedSeries(_ series: [Serie]) -> [Serie] {
        fetchedSeries += series

        return fetchedSeries
    }
    
    func findFetchedSerie(with id: Int) -> Serie? {
        fetchedSeries.first {
            $0.id == id
        }
    }
    
    func isLastSeriesId(_ serieId: Int) -> Bool {
        fetchedSeries.last?.id == serieId
    }
    
    func getNextPage() -> Int {
        guard let lastFetchedPage else {
            return 0
        }
        return lastFetchedPage + 1
    }
    
    func setPage(to page: Int?) {
        lastFetchedPage = page
    }
}
