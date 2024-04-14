import SwiftUI

protocol SeriesDetailingViewStating: AnyObject {
    var viewModel: DetailableSerieViewModel? { get set }
    var episodesState: SeriesDetailEpisodesState { get set }
    var isPresentingEpisode: Bool { get set }
    var presentingEpisode: EpisodeViewModel? { get set }
    var isFavorite: Bool { get set }
}

final class SeriesDetailingViewState: ObservableObject, SeriesDetailingViewStating {
    @Published var viewModel: DetailableSerieViewModel?
    @Published var episodesState: SeriesDetailEpisodesState = .presentingLoading
    @Published var isPresentingEpisode: Bool = false
    @Published var presentingEpisode: EpisodeViewModel?
    @Published var isFavorite = false
}
