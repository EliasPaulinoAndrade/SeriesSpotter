import Foundation

enum SeriesDetailEpisodesState {
    case presentingLoading
    case presentingError
    case presentingEpisodes([EpisodeViewModel])
}
