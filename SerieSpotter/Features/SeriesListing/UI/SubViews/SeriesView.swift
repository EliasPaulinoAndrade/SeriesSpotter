import SwiftUI

struct SeriesView: View {
    let viewModels: [ListableSerieViewModel]
    let onSerieAppear: (_ serieId: Int) async -> Void
    let onSerieTapped: (_ serieId: Int) -> Void
    
    private let columns = [
        GridItem(
            .adaptive(minimum: 100, maximum: 100),
            spacing: Space.base03,
            alignment: .topLeading
        )
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModels, id: \.id) { viewModel in
                    SerieView(viewModel: viewModel)
                        .onTapGesture {
                            onSerieTapped(viewModel.id)
                        }
                        .task {
                            await onSerieAppear(viewModel.id)
                        }
                }
                .padding(.top, Space.base03)
            }.background(Color(.backgroundPrimary))
        }
    }
}
