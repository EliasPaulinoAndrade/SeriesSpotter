import Foundation

protocol SeriesDetailingPresenting {
    @MainActor
    func presentSerie(serie: Serie)
    @MainActor
    func presentEpisodes(_ episodes: [Episode])
    @MainActor
    func presentLoading()
    @MainActor
    func presentError()
    @MainActor
    func presentFavorite(isFavorite: Bool)
    func close()
    func presentEpisodeDetail(episode: Episode)
}

struct SeriesDetailingPresenter {
    let listingNavigationState: SeriesListingNavigationStating
    let viewState: SeriesDetailingViewStating
}

extension SeriesDetailingPresenter: SeriesDetailingPresenting {
    func presentSerie(serie: Serie) {
        let viewModel = getViewModel(for: serie)
        
        viewState.viewModel = viewModel
    }
    
    func close() {
        listingNavigationState.isPresentingSerie = false
    }
    
    func presentEpisodes(_ episodes: [Episode]) {
        let viewModels = episodes.map(getEpisodeViewModel)
        
        viewState.episodesState = .presentingEpisodes(viewModels)
    }
    
    func presentLoading() {
        viewState.episodesState = .presentingLoading
    }
    
    func presentError() {
        viewState.episodesState = .presentingError
    }
    
    func presentFavorite(isFavorite: Bool) {
        viewState.isFavorite = isFavorite
    }
    
    func presentEpisodeDetail(episode: Episode) {
        let viewModel = getEpisodeViewModel(from: episode)

        viewState.presentingEpisode = viewModel
        viewState.isPresentingEpisode = true
    }
}

private extension SeriesDetailingPresenter {
    func getEpisodeViewModel(from episode: Episode) -> EpisodeViewModel {
        EpisodeViewModel(
            id: episode.id,
            name: episode.name,
            numberInfo: "Season \(episode.season) - Episode \(episode.number)",
            imageUrl: episode.imageUrl,
            summary: episode.summary?.removingHTMLTags() ?? ""
        )
    }
    
    func getViewModel(for serie: Serie) -> DetailableSerieViewModel {
        DetailableSerieViewModel(
            id: serie.id,
            name: serie.name,
            imageUrl: serie.imageUrl,
            genres: serie.genres.joined(separator: " • "),
            summary: getFormattedSummary(for: serie.summary),
            timeInfo: getTimeInfo(for: serie),
            isFavorite: false
        )
    }
    
    func getDayTimeInfo(for serie: Serie) -> String {
        let timeInfo = getTimeInfo(for: serie)
        
        guard let lastDay = serie.airDays.last else {
            return timeInfo
        }
        
        guard serie.airDays.count > 1 else {
            return "\(lastDay) \(timeInfo)"
        }
        var airDays = serie.airDays
        airDays.removeLast()

        return "\(airDays.joined(separator: ",")) and \(lastDay) \(timeInfo)"
    }
    
    func getTimeInfo(for serie: Serie) -> String {
        guard !serie.airTime.isEmpty else {
            return ""
        }

        return "at \(serie.airTime)"
    }
    
    func getFormattedSummary(for summary: String?) -> String {
        summary?.removingHTMLTags() ?? ""
    }
}
