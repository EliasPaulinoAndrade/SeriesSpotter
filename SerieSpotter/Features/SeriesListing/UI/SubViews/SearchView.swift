import SwiftUI

struct SearchView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    let onToggleSearch: (_ isSearching: Bool) -> Void
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        Group {
            content()
        }.onChange(of: isSearching) { _, isSearching in
            onToggleSearch(isSearching)
        }
    }
}
