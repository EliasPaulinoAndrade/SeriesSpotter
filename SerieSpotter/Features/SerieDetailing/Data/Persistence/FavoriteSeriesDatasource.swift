import Foundation
import SwiftData

protocol FavoriteSeriesDatasourcing {
    func save(serie: Serie, asFavorite isFavorite: Bool) async throws
    func isSerieFavorite(serie: Serie) async -> Bool
}

struct FavoriteSeriesDatasource: FavoriteSeriesDatasourcing {
    let stack: SwiftDataStacking
    
    @MainActor
    func save(serie: Serie, asFavorite isFavorite: Bool) throws {
        guard isFavorite else {
            return try deleteFavoriteSerie(id: serie.id)
        }

        let serieDTO = FavoriteSerieDTO(serie: serie)
        
        stack.context?.insert(serieDTO)
        try stack.context?.save()
    }
    
    @MainActor
    func isSerieFavorite(serie: Serie) -> Bool {
        return isSerieFavorite(id: serie.id)
    }
}

private extension FavoriteSeriesDatasource {
    @MainActor
    private func deleteFavoriteSerie(id: Int) throws {
        let fetchDescriptor = FetchDescriptor<FavoriteSerieDTO>(predicate: #Predicate {
            $0.serieId == id
        })
        
        guard let serieToDelete = try stack.context?.fetch(fetchDescriptor).first else {
            throw PersistenceError.cantFindFavoriteSerie
        }
        
        stack.context?.delete(serieToDelete)
    }
    
    @MainActor
    private func isSerieFavorite(id: Int) -> Bool {
        let fetchDescriptor = FetchDescriptor<FavoriteSerieDTO>(predicate: #Predicate {
            $0.serieId == id
        })
        guard let favoritesSeries = try? stack.context?.fetch(fetchDescriptor) else {
            return false
        }
        
        return favoritesSeries.contains { dto in
            dto.serieId == id
        }
    }
}
