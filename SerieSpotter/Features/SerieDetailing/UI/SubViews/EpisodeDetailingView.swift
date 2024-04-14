import SwiftUI

struct EpisodeDetailingView: View {
    let viewModel: EpisodeViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                EpisodeHeaderView(viewModel: viewModel)
                Text(viewModel.summary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Space.base03)
                    .padding(.horizontal, Space.base01)
                    .font(.subheadline)
            }
        }.background(.backgroundSecondary)
    }
}

#Preview {
    EpisodeDetailingView(viewModel: .init(
        id: 1,
        name: "the walking dead",
        numberInfo: "ewfewf",
        imageUrl: URL(string: "https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2022/11/23/655212124-the-walking-dead.jpg"),
        summary: "summary"
    ))
}
