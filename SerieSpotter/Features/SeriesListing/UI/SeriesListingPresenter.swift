import Foundation

@MainActor
protocol SeriesListingPresenting {
    func presentLoading()
    func presentError()
    func presentEmptyState()
    func presentSeries(series: [Serie])
    func presentSerieDetail(serie: Serie)
}

struct SeriesListingPresenter {
    let viewState: SeriesListingViewStating
    let navigationState: SeriesListingNavigationStating
}

extension SeriesListingPresenter: SeriesListingPresenting {
    func presentLoading() {
        viewState.listState = .presentingLoading
    }
    
    func presentError() {
        viewState.listState = .presentingError
    }
    
    func presentEmptyState() {
        viewState.listState = .presentingEmptyState
    }
    
    func presentSeries(series: [Serie]) {
        let viewModels = series.map { serie in
            ListableSerieViewModel(id: serie.id, name: serie.name, imageUrl: serie.imageUrl)
        }
        
        viewState.listState = .presentingSeries(viewModels)
    }
    
    func presentSerieDetail(serie: Serie) {
        navigationState.presentingSerie = serie
        navigationState.isPresentingSerie = true
    }
}
