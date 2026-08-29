import SwiftUI

struct TVShowDetailView: View {
    let show: MediaItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdropImage
                infoSection
                    .padding()
            }
        }
        .navigationTitle(show.title)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Subviews

    /// Full-width backdrop loaded from the TMDB image CDN at 780px width.
    @ViewBuilder
    private var backdropImage: some View {
        AsyncImage(url: backdropURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fit)
            case .failure, .empty:
                Rectangle()
                    .fill(Color(.secondarySystemBackground))
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay {
                        Image(systemName: "tv")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }
            @unknown default:
                EmptyView()
            }
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(show.title)
                .font(.title2)
                .fontWeight(.bold)

            Text(String(format: "⭐️ %.1f", show.voteAverage))
                .font(.subheadline)
                .fontWeight(.semibold)

            // First air date — optional since some shows omit it
            if let releaseDate = show.releaseDate, !releaseDate.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                    Text(releaseDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            Text(show.overview)
                .font(.body)
                .lineSpacing(4)
        }
    }

    // MARK: - Helpers

    /// Builds the full backdrop URL using the wider 780px image size.
    private var backdropURL: URL? {
        guard let path = show.backdropPath else { return nil }
        return URL(string: TMDBConfig.backdropBaseURL + path)
    }
}
