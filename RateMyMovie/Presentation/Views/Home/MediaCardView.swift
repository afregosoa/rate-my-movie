import SwiftUI

/// A card displaying a media item's poster image, title, and media type badge.
/// Used across Trending, Free To Watch, and What's Popular sections.
struct MediaCardView: View {
    let item: MediaItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            posterImage
            overlay
        }
        .frame(width: 140, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Subviews

    @ViewBuilder
    private var posterImage: some View {
        if let posterPath = item.posterPath {
            AsyncImage(url: URL(string: TMDBConfig.imageBaseURL + posterPath)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure, .empty:
                    placeholderBackground
                @unknown default:
                    placeholderBackground
                }
            }
        } else {
            placeholderBackground
        }
    }

    private var placeholderBackground: some View {
        Rectangle().fill(Color(.systemGray5))
    }

    private var overlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Spacer()
            // Media type badge
            Text(item.mediaType.displayName)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            Text(item.title)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundStyle(.white)
                .shadow(radius: 2)
        }
        .padding(8)
        .background(
            // Gradient so text is readable over any poster colour
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
        )
    }
}

private extension MediaItem.MediaType {
    var displayName: String {
        switch self {
        case .movie: return "Movie"
        case .tv: return "TV"
        case .person: return "Person"
        }
    }
}
