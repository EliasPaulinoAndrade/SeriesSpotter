import SwiftUI

struct SeriesErrorView: View {
    let text: String
    let onRetryTapped: () -> Void
    
    var body: some View {
        Text(text)
            .foregroundStyle(.textSecondary)
            .padding(Space.base03)
        Button {
            onRetryTapped()
        } label: {
            Image(systemName: "arrow.circlepath")
        }
    }
}
