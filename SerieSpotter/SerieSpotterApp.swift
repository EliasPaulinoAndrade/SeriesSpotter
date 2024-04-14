import SwiftUI

@main
struct SerieSpotterApp: App {
    var body: some Scene {
        WindowGroup {
            SeriesListingFactory().makeListing()
        }
    }
}
