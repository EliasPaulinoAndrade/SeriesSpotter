import Foundation
import SwiftData

protocol SwiftDataStacking {
    @MainActor
    var context: ModelContext? { get }
}

final class SwiftDataStack: SwiftDataStacking {
    static let stack = SwiftDataStack()
    
    let container = try? ModelContainer(for: FavoriteSerieDTO.self)
    lazy var context = container?.mainContext
    
    private init() { }
}
