import Foundation

struct EpisodeDTO: Decodable {
    let id: Int
    let name: String
    let number: Int
    let season: Int
    let summary: String?
    let image: ImageDTO?
}
