import Foundation

protocol EpisodesListingServicing {
    func fetchEpisodes(for serieId: Int) async throws -> [Episode]
}

struct EpisodesListingService {
    let requester: Requester<[EpisodeDTO]>
}

extension EpisodesListingService: EpisodesListingServicing {
    func fetchEpisodes(for serieId: Int) async throws -> [Episode] {
        let target = EpisodesApi(serieId: serieId)
        let episodeDTOs = try await requester.request(target: target)
        let episodes = getEpisodes(from: episodeDTOs)
        return episodes
    }
    
    private func getEpisodes(from episodeDTOs: [EpisodeDTO]) -> [Episode] {
        episodeDTOs.map { dto in
            Episode(
                id: dto.id,
                name: dto.name,
                number: dto.number,
                season: dto.season,
                summary: dto.summary,
                imageUrl: dto.image?.medium
            )
        }
    }
}
