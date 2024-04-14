import SwiftUI

struct SeriesDetailingView: View {
    let interactor: SeriesDetailingInteracting
    @ObservedObject var viewState: SeriesDetailingViewState
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack {
                    detailView
                }.padding(.top, Space.base02)
            }
            SeriesDetailingCloseButton {
                interactor.selectedClose()
            }
        }.background(Color.backgroundPrimary)
         .sheet(isPresented: $viewState.isPresentingEpisode) {
             Group {
                 if let viewModel = viewState.presentingEpisode {
                     EpisodeDetailingView(viewModel: viewModel)
                         .presentationDetents([.medium, .large])
                 }
             }
         }
         .task {
            await interactor.started()
         }
         .onChange(of: viewState.isFavorite) { _, newValue in
             Task {
                 await interactor.favorited(isFavorite: newValue)
             }
         }
    }
    
    @ViewBuilder
    var detailView: some View {
        if let viewModel = viewState.viewModel {
            SeriesDetailingHeaderView(viewModel: viewModel, isFavorite: $viewState.isFavorite)
            SeriesDetailingSummaryView(viewModel: viewModel)
        }
        
        switch viewState.episodesState {
        case .presentingLoading:
            ProgressView()
        case .presentingError:
            SeriesErrorView(text: "Couldnt load the episodes. Tap the button below for trying again") {
                interactor.selectedRetry()
            }
        case .presentingEpisodes(let episodes):
            EpisodesListingView(episodes: episodes) { episodeId in
                interactor.selectedEpisode(with: episodeId)
            }
        }
    }
}

#Preview {
    SerieDetailingFactory().makeDetail(
        for: Serie(
            id: 1,
            name: "name",
            imageUrl: URL(string: "https://www.guiadasemana.com.br/contentFiles/system/pictures/2016/7/165817/original/poster.jpg"),
            genres: ["genre1", "genre2"],
            summary: "<p>Set against the stunning backdrop of one of the world's most prestigious educational institutions, Cambridge University, <b>Professor T</b> is centered around the eccentric, but brilliant Criminology Professor Jasper Tempest, who suffers with OCD and has a tortured past.</p><p>Set against the stunning backdrop of one of the world's most prestigious educational institutions, Cambridge University, <b>Professor T</b> is centered around the eccentric, but brilliant Criminology Professor Jasper Tempest, who suffers with OCD and has a tortured past.</p><p>Set against the stunning backdrop of one of the world's most prestigious educational institutions, Cambridge University, <b>Professor T</b> is centered around the eccentric, but brilliant Criminology Professor Jasper Tempest, who suffers with OCD and has a tortured past.</p><p>Set against the stunning backdrop of one of the world's most prestigious educational institutions, Cambridge University, <b>Professor T</b> is centered around the eccentric, but brilliant Criminology Professor Jasper Tempest, who suffers with OCD and has a tortured past.</p>",
            airTime: "12:30",
            airDays: ["day1", "day2"]
        ),
        listNavigationState: SeriesListingNavigationState()
    )
}
