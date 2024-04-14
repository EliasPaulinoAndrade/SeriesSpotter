import Foundation

protocol SeriesDetailingInteracting {
    func started() async
    func selectedClose()
    func selectedRetry()
    func selectedEpisode(with id: Int)
    func favorited(isFavorite: Bool) async
}

final class SeriesDetailingInteractor {
    private let serie: Serie
    private let presenter: SeriesDetailingPresenting
    private let service: EpisodesListingServicing
    private let favoritesDatasource: FavoriteSeriesDatasourcing
    private var isFavorite: Bool = false
    
    private var fetchedEpisodes: [Episode] = []
    
    init(serie: Serie, presenter: SeriesDetailingPresenting, service: EpisodesListingServicing, favoritesDatasource: FavoriteSeriesDatasourcing) {
        self.serie = serie
        self.presenter = presenter
        self.service = service
        self.favoritesDatasource = favoritesDatasource
    }
}

extension SeriesDetailingInteractor: SeriesDetailingInteracting {
    func started() async {
        await presenter.presentSerie(serie: serie)
        await fetchEpisodes()
        await presenter.presentFavorite(isFavorite: await isSerieFavorite())
    }
    
    func selectedClose() {
        presenter.close()
    }
    
    func selectedRetry() {
        Task {
            await fetchEpisodes()
        }
    }
    
    func selectedEpisode(with id: Int) {
        let episode = fetchedEpisodes.first { $0.id == id }
        
        guard let episode else {
            return
        }
                
        presenter.presentEpisodeDetail(episode: episode)
    }
    
    func favorited(isFavorite: Bool) async {
        guard self.isFavorite != isFavorite else { return }
        do {
            try await favoritesDatasource.save(serie: serie, asFavorite: isFavorite)
            self.isFavorite = isFavorite
        } catch {
            await presenter.presentFavorite(isFavorite: self.isFavorite)
        }
    }
}

private extension SeriesDetailingInteractor {
    func fetchEpisodes() async {
        do {
            await presenter.presentLoading()
            let episodes = try await service.fetchEpisodes(for: serie.id)
            fetchedEpisodes = episodes
            await presenter.presentEpisodes(episodes)
        } catch {
            await presenter.presentError()
        }
    }
    
    func isSerieFavorite() async -> Bool {
        isFavorite = await favoritesDatasource.isSerieFavorite(serie: serie)
        return isFavorite
    }
}
