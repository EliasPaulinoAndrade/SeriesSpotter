import Foundation

struct SeriesListingFactory {
    func makeListing() -> SeriesListingView {
        let navigationState = SeriesListingNavigationState()
        let viewState = SeriesListingViewState()
        let preseter = SeriesListingPresenter(viewState: viewState, navigationState: navigationState)
        let listService = SeriesListingService(requester: RequesterFactory().makeRequester())
        let searchService = SeriesSearchingService(requester: RequesterFactory().makeRequester())
        let interactor = SeriesListingInteractor(presenter: preseter, listService: listService, searchService: searchService)

        return SeriesListingView(interactor: interactor, viewState: viewState, navigationState: navigationState)
    }
}
