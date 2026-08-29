import Foundation

final class FreeToWatchRepository: FreeToWatchRepositoryProtocol {
    private let service: TMDBServiceProtocol

    init(service: TMDBServiceProtocol) {
        self.service = service
    }

    /// Fetches free-to-watch content and maps DTOs to domain `MediaItem` entities.
    func fetchFreeToWatch(filter: FreeToWatchFilter) async throws -> [MediaItem] {
        switch filter {
        case .movies:
            let response = try await service.fetchFreeToWatchMovies()
            return response.results.map { $0.toMediaItem() }
        case .tv:
            let response = try await service.fetchFreeToWatchTV()
            return response.results.map { $0.toMediaItem() }
        }
    }
}

private extension MovieDTO {
    /// Maps a movie DTO to a `MediaItem` with `.movie` media type.
    func toMediaItem() -> MediaItem {
        MediaItem(
            id: id,
            title: title,
            mediaType: .movie,
            posterPath: posterPath,
            backdropPath: backdropPath,
            overview: overview,
            voteAverage: voteAverage,
            releaseDate: releaseDate
        )
    }
}

private extension TVShowDTO {
    /// Maps a TV show DTO to a `MediaItem` with `.tv` media type.
    func toMediaItem() -> MediaItem {
        MediaItem(
            id: id,
            title: name,
            mediaType: .tv,
            posterPath: posterPath,
            backdropPath: backdropPath,
            overview: overview,
            voteAverage: voteAverage,
            releaseDate: firstAirDate
        )
    }
}
