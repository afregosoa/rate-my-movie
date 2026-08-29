import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdropImage
                infoSection
                    .padding()
            }
        }
        .navigationTitle(movie.title)
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
                        Image(systemName: "film")
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
            // Title
            Text(movie.title)
                .font(.title2)
                .fontWeight(.bold)

            // Vote average and vote count on the same line
            HStack(spacing: 8) {
                Text(String(format: "⭐️ %.1f", movie.voteAverage))
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("(\(movie.voteCount.formatted()) votes)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Release date
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            // Full overview text
            Text(movie.overview)
                .font(.body)
                .lineSpacing(4)
        }
    }

    // MARK: - Helpers

    /// Builds the full backdrop URL using the wider 780px image size.
    private var backdropURL: URL? {
        guard let path = movie.backdropPath else { return nil }
        return URL(string: TMDBConfig.backdropBaseURL + path)
    }
}
