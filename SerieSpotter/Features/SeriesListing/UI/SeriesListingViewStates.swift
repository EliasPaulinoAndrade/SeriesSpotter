import Foundation
import SwiftUI

protocol SeriesListingViewStating: AnyObject {
    var listState: SeriesListState { get set }
}

protocol SeriesListingNavigationStating: AnyObject {
    var isPresentingSerie: Bool { get set }
    var presentingSerie: Serie? { get set }
}

final class SeriesListingViewState: ObservableObject, SeriesListingViewStating {
    @Published var listState: SeriesListState = .presentingLoading
    @Published var searchText = ""
}

final class SeriesListingNavigationState: ObservableObject, SeriesListingNavigationStating {
    @Published var isPresentingSerie: Bool = false
    @Published var presentingSerie: Serie?
}
