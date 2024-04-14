import Foundation

struct Serie: Equatable {
    let id: Int
    let name: String
    let imageUrl: URL?
    let genres: [String]
    let summary: String?
    let airTime: String
    let airDays: [String]
}
