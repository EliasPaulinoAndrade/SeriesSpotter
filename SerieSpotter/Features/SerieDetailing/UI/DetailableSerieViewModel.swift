import Foundation

struct DetailableSerieViewModel: Equatable {
    let id: Int
    let name: String
    let imageUrl: URL?
    let genres: String
    let summary: String
    let timeInfo: String
    let isFavorite: Bool
}
