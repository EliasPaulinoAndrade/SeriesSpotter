import SwiftUI

struct SerieView: View {
    let viewModel: ListableSerieViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            SeriePosterView(imageUrl: viewModel.imageUrl)

            Text(viewModel.name)
                .foregroundStyle(.textSecondary)
                .bold()
        }
    }
}

#Preview {
    SerieView(viewModel: ListableSerieViewModel(id: 1, name: "name", imageUrl: URL(string: "https://www.guiadasemana.com.br/contentFiles/system/pictures/2016/7/165817/original/poster.jpg")))
}
