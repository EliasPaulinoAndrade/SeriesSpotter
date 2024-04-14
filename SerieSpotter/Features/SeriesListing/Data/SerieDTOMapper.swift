import Foundation

enum SerieDTOMapper {
    static func getSeries(from seriesDTOs: [SeriesDTO.Serie]) -> [Serie] {
        seriesDTOs.map { dto in
            Serie(
                id: dto.id,
                name: dto.name,
                imageUrl: dto.image?.medium,
                genres: dto.genres,
                summary: dto.summary,
                airTime: dto.schedule.time,
                airDays: dto.schedule.days
            )
        }
    }
}
