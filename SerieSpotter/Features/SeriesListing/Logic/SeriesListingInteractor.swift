import Foundation

protocol SeriesListingInteracting {
    func started() async
    func showedSerie(with id: Int) async
    func changedSearch(query: String) async
    func toggledSearch(isSearching: Bool) async
    func selectedRetry() async
    func selectedSerie(with id: Int) async
}

final class SeriesListingInteractor {
    private let presenter: SeriesListingPresenting
    private let listService: SeriesListingServicing
    private let searchService: SeriesSearchingServicing
    private let state = SeriesListingState()
    
    init(presenter: SeriesListingPresenting, listService: SeriesListingServicing, searchService: SeriesSearchingServicing) {
        self.presenter = presenter
        self.listService = listService
        self.searchService = searchService
    }
}

extension SeriesListingInteractor: SeriesListingInteracting {
    func started() async {
        await fetchNextPage(presentLoading: presenter.presentLoading)
    }
    
    func showedSerie(with id: Int) async {
        guard await shouldRequestNextPage(with: id) else {
            return
        }
        
        await fetchNextPage(presentLoading: nil)
    }
    
    func changedSearch(query: String) async {
        guard !query.isEmpty else {
            return
        }
        
        await searchPage(with: query)
    }
    
    func toggledSearch(isSearching: Bool) async {
        guard await shouldReloadFirstPage(isSearching: isSearching) else {
            return
        }
        await state.cleanFetchedSeries()
        await fetchNextPage(presentLoading: presenter.presentLoading)
    }
    
    func selectedRetry() async {
        await fetchNextPage(presentLoading: presenter.presentLoading)
    }
    
    func selectedSerie(with id: Int) async {
        guard let selectedSerie = await state.findFetchedSerie(with: id) else {
            return
        }
        await presenter.presentSerieDetail(serie: selectedSerie)
    }
}

private extension SeriesListingInteractor {
    func shouldRequestNextPage(with serieId: Int) async -> Bool {
        let wasLastSerieShowed = await state.isLastSeriesId(serieId)
        let didLoadFirstPage = await state.hasLoadedPage

        return wasLastSerieShowed && didLoadFirstPage
    }
    
    func shouldReloadFirstPage(isSearching: Bool) async -> Bool {
        let didUserTypeQuery = await !state.hasLoadedPage

        return !isSearching && didUserTypeQuery
    }
    
    func fetchNextPage(presentLoading: (() async -> Void)?) async {
        let nextPage = await state.getNextPage()
        
        do {
            await presentLoading?()
            let series = try await listService.fetchSeries(at: nextPage)
            let updatedSeries = await state.incrementFetchedSeries(series)
            
            await state.setPage(to: nextPage)
            await presenter.presentSeries(series: updatedSeries)
        } catch {
            await presenter.presentError()
        }
    }
    
    func searchPage(with query: String) async {
        await state.setPage(to: nil)
        await state.cleanFetchedSeries()

        do {
            await presenter.presentLoading()
            let series = try await searchService.searchSeries(query: query)
            let updatedSeries = await state.incrementFetchedSeries(series)
            
            guard updatedSeries.isEmpty else {
                return await presenter.presentSeries(series: updatedSeries)
            }
            await presenter.presentEmptyState()
        } catch {
            await presenter.presentError()
        }
    }
}
