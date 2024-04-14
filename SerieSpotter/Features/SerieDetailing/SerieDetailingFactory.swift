import Foundation

struct SerieDetailingFactory {
    func makeDetail(for serie: Serie, listNavigationState: SeriesListingNavigationStating) -> SeriesDetailingView {
        let viewState = SeriesDetailingViewState()
        let presenter = SeriesDetailingPresenter(listingNavigationState: listNavigationState, viewState: viewState)
        let service = EpisodesListingService(requester: RequesterFactory().makeRequester())
        let datasource = FavoriteSeriesDatasource(stack: SwiftDataStack.stack)
        let interactor = SeriesDetailingInteractor(serie: serie, presenter: presenter, service: service, favoritesDatasource: datasource)
        
        return SeriesDetailingView(interactor: interactor, viewState: viewState)
    }
}

