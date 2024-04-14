import SwiftUI

struct SeriesListingView: View {
    let interactor: SeriesListingInteracting
    @ObservedObject var viewState: SeriesListingViewState
    @ObservedObject var navigationState: SeriesListingNavigationState
    
    var body: some View {
        NavigationStack {
            SearchView {
                listingView
            } onToggleSearch: { isSearching in
                Task {
                    await interactor.toggledSearch(isSearching: isSearching)
                }
            }.navigationTitle("Shows")
                .toolbarBackground(Color(.backgroundSecondary), for: .navigationBar)
                .task {
                    await interactor.started()
                }
        }.searchable(text: $viewState.searchText)
         .onChange(of: viewState.searchText) { _, searchText in
            Task {
                await interactor.changedSearch(query: searchText)
            }
         }
         .sheet(isPresented: $navigationState.isPresentingSerie) {
            Group {
                if let serie = navigationState.presentingSerie {
                    SerieDetailingFactory()
                        .makeDetail(for: serie, listNavigationState: navigationState)
                }
            }
         }
    }
    
    @ViewBuilder
    var listingView: some View {
        switch viewState.listState {
        case .presentingSeries(let viewModels):
            SeriesView(viewModels: viewModels) { serieId in
                await interactor.showedSerie(with: serieId)
            } onSerieTapped: { serieId in
                Task {
                    await interactor.selectedSerie(with: serieId)
                }
            }
        case .presentingError:
            SeriesErrorView(text: "Couldnt load the series. Tap the button below for trying again") {
                Task {
                    await interactor.selectedRetry()
                }
            }
        case .presentingEmptyState:
            SeriesEmptyView()
        case .presentingLoading:
            ProgressView()
        }
    }
}

#Preview {
    SeriesListingFactory().makeListing()
}
