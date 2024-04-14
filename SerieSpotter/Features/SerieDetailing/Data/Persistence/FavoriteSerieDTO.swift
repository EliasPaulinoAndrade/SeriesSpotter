import SwiftData
import Foundation

@Model
class FavoriteSerieDTO {
    @Attribute(.unique) var serieId: Int
    let name: String
    let imageUrl: URL?
    let genres: [String]
    let summary: String?
    let airTime: String
    let airDays: [String]
    
    init(serie: Serie) {
        self.serieId = serie.id
        self.name = serie.name
        self.imageUrl = serie.imageUrl
        self.genres = serie.genres
        self.summary = serie.summary
        self.airTime = serie.airTime
        self.airDays = serie.airDays
    }
}
