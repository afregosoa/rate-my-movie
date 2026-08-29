import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            posterImage
            info
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Subviews

    /// Loads the poster asynchronously from the TMDB image CDN.
    @ViewBuilder
    private var posterImage: some View {
        AsyncImage(url: posterURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
            case .failure, .empty:
                placeholderPoster
            @unknown default:
                placeholderPoster
            }
        }
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)

            // Vote average is out of 10; formatted to 1 decimal place
            Text(String(format: "⭐️ %.1f", movie.voteAverage))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(8)
    }

    private var placeholderPoster: some View {
        Rectangle()
            .fill(Color(.tertiarySystemBackground))
            .aspectRatio(2/3, contentMode: .fit)
            .overlay {
                Image(systemName: "film")
                    .foregroundStyle(.secondary)
            }
    }

    // MARK: - Helpers

    /// Builds the full poster URL by prepending the TMDB image base URL.
    private var posterURL: URL? {
        guard let path = movie.posterPath else { return nil }
        return URL(string: TMDBConfig.imageBaseURL + path)
    }
}
