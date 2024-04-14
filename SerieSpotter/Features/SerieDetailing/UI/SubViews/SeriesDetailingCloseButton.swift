import SwiftUI

struct SeriesDetailingCloseButton: View {
    let onButtonTapped: () -> Void
    
    var body: some View {
        Button {
            onButtonTapped()
        } label: {
            HStack {
                Image(systemName: "xmark")
            }
            .padding(Space.base02)
            .background(Color.action)
            .mask(Circle())
        }.tint(Color.textPrimary)
         .padding(.trailing,  Space.base01)
         .padding(.top, Space.base01)
         .shadow(color: .backgroundSecondary, radius: 2)
    }
}
