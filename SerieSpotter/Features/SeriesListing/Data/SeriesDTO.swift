import Foundation

enum SeriesDTO {
    struct SearchResult: Decodable {
        let show: Serie
    }
    
    struct Serie: Decodable {
        let id: Int
        let name: String
        let image: ImageDTO?
        let genres: [String]
        let summary: String?
        let schedule: Schedule
    }
    
    struct Schedule: Decodable {
        let time: String
        let days: [String]
    }
}
