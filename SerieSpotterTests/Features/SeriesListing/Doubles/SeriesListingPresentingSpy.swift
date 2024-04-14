import Foundation
@testable import SerieSpotter

final class SeriesListingPresentingSpy {
    enum Messages: Equatable {
        case presentLoading
        case presentError
        case presentEmptyState
        case presentSeries([Serie])
        case presentSerieDetail(Serie)
    }
    
    private(set) var messages: [Messages] = []
}

extension SeriesListingPresentingSpy: SeriesListingPresenting {
    func presentLoading() {
        messages.append(.presentLoading)
    }
    
    func presentError() {
        messages.append(.presentError)
    }
    
    func presentEmptyState() {
        messages.append(.presentEmptyState)
    }
    
    func presentSeries(series: [Serie]) {
        messages.append(.presentSeries(series))
    }
    
    func presentSerieDetail(serie: Serie) {
        messages.append(.presentSerieDetail(serie))
    }
}
