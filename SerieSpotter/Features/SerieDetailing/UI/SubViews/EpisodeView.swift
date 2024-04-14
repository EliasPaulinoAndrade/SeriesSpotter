import SwiftUI

struct EpisodeView: View {
    let viewModel: EpisodeViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            AsyncImage(url: viewModel.imageUrl) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }.scaledToFill()
             .aspectRatio(contentMode: .fill)
             .frame(width: 200, height: 200)
             .clipped()
             .contentShape(Rectangle())
             .background(Color(.action))
    
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .bold()
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(viewModel.numberInfo)
                    .font(.caption)
            }.padding(.vertical, Space.base01)
             .padding(.horizontal, Space.base02)
             .frame(maxWidth: .infinity)
             .background(
                Color.backgroundSecondary
                    .opacity(0.7)
             )
        }.frame(width: 200)
         .clipShape(
            RoundedRectangle(cornerSize: .init(
                width: Space.base03,
                height: Space.base03
            ))
         )
    }
}
