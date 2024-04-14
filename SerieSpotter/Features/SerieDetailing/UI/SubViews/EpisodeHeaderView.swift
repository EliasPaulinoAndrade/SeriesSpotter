import SwiftUI

struct EpisodeHeaderView: View {
    let viewModel: EpisodeViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: viewModel.imageUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(maxWidth: .infinity)
             .frame(height: 250)
             .clipShape(.rect(
                cornerSize: .init(
                    width: Space.base01,
                    height: Space.base01
                )
             ))
            
            Group {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .bold()
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(viewModel.numberInfo)
                        .font(.caption)
                        .bold()
                }.padding(Space.base01)
            }.alignmentGuide(.bottom) { dimension in
                dimension[VerticalAlignment.center]
            }.frame(maxWidth: .infinity)
             .background(Color.action)
             .clipShape(.rect(
                cornerSize: .init(
                    width: Space.base01,
                    height: Space.base01
                )))
             .padding()
        }
    }
}
