import Foundation

struct EpisodesApi: RequestTarget {
    let serieId: Int
    
    var path: String {
        return "/shows/\(serieId)/episodes"
    }
}
