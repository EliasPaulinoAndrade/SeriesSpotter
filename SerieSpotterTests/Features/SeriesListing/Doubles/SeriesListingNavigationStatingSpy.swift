import Foundation
@testable import SerieSpotter

final class SeriesListingNavigationStatingSpy: SeriesListingNavigationStating {
    var isPresentingSerie: Bool = false
    var presentingSerie: Serie?
}
