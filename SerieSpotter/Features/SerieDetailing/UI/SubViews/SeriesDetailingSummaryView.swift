import SwiftUI

struct SeriesDetailingSummaryView: View {
    let viewModel: DetailableSerieViewModel
    
    var body: some View {
        Text(viewModel.genres)
            .foregroundStyle(.textSecondary)
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Space.base01)
            .padding(.horizontal, Space.base01)
            .bold()
        Text(viewModel.summary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Space.base03)
            .padding(.horizontal, Space.base01)
            .font(.subheadline)
    }
}
