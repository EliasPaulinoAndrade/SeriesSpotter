import SwiftUI

struct SeriePosterView: View {
    let imageUrl: URL?
    
    var body: some View {
        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
        } placeholder: {
            ProgressView()
        }.frame(width: 100, height: 150)
         .background(Color(.action))
         .clipShape(
            RoundedRectangle(cornerSize: .init(
                width: Space.base03,
                height: Space.base03
            ))
         )
    }
}
