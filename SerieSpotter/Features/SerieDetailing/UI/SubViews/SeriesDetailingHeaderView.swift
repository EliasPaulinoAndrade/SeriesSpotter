import SwiftUI

struct SeriesDetailingHeaderView: View {
    @State var viewModel: DetailableSerieViewModel
    @Binding var isFavorite: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            SeriePosterView(imageUrl: viewModel.imageUrl)
                .shadow(color: .backgroundSecondary, radius: 5)
            Group {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.name)
                            .bold()
                            .font(.title3)
                        Spacer()
                        Toggle("", isOn: $isFavorite)
                         .toggleStyle(StarToggleStyle())
                         .tint(.textPrimary)
                    }
                    Text(viewModel.timeInfo)
                        .padding(.top, Space.base01)
                        .font(.body)
                }.padding(Space.base01)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.action)
                .clipShape(
                    .rect(
                        bottomTrailingRadius: Space.base01,
                        topTrailingRadius: Space.base01
                    )
                )
                .padding(.bottom, Space.base03)
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Space.base01)
    }
}

struct StarToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            if configuration.isOn {
                Image(systemName: "star.fill")
            } else {
                Image(systemName: "star")
            }
        }
    }
}
