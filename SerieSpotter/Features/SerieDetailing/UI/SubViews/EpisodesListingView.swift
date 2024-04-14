import SwiftUI

struct EpisodesListingView: View {
    let episodes: [EpisodeViewModel]
    let onTapEpisode: (_ episodeId: Int) -> Void
    
    var body: some View {
        if !episodes.isEmpty {
            Text("Episodes")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Space.base02)
                .padding(.top, Space.base05)
        }
        
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(episodes, id: \.id) { episode in
                    EpisodeView(viewModel: episode)
                        .onTapGesture {
                            onTapEpisode(episode.id)
                        }
                }
            }.padding(.horizontal, Space.base02)
        }.padding(.top, Space.base01)
    }
}
