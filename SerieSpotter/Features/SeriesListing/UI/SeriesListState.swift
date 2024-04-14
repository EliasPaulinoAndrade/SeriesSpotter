import Foundation

enum SeriesListState: Equatable {
    case presentingSeries([ListableSerieViewModel])
    case presentingError
    case presentingEmptyState
    case presentingLoading
}
