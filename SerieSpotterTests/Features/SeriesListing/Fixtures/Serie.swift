import Foundation
@testable import SerieSpotter

extension Serie {
    static func fixture(
        id: Int = 1,
        name: String = "name",
        imageUrl: URL? = nil,
        genres: [String] = ["horror"],
        summary: String? = nil,
        airTime: String = "",
        airDays: [String] = []
    ) -> Self {
        Self(
            id: id,
            name: name,
            imageUrl: imageUrl,
            genres: genres,
            summary: summary,
            airTime: airTime,
            airDays: airDays
        )
    }
}
