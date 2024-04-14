import Foundation
@testable import SerieSpotter

final class SeriesListingViewStatingSpy: SeriesListingViewStating {
    var listState: SeriesListState = .presentingLoading
}
