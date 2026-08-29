import Foundation

final class TrendingRepository: TrendingRepositoryProtocol {
    private let service: TMDBServiceProtocol

    init(service: TMDBServiceProtocol = TMDBService()) {
        self.service = service
    }

    /// Fetches trending items and maps DTOs to domain entities.
    func fetchTrending(timeWindow: TimeWindow) async throws -> [MediaItem] {
        let response = try await service.fetchTrending(timeWindow: timeWindow)
        return response.results.compactMap { $0.toDomain() }
    }
}

private extension TrendingItemDTO {
    /// Maps a DTO to a domain `MediaItem`.
    /// Uses `title` for movies and `name` for TV/person, falling back to an empty string.
    func toDomain() -> MediaItem? {
        guard let mediaType = MediaItem.MediaType(rawValue: mediaType) else { return nil }

        let resolvedTitle: String
        switch mediaType {
        case .movie:
            resolvedTitle = title ?? ""
        case .tv, .person:
            resolvedTitle = name ?? ""
        }

        return MediaItem(
            id: id,
            title: resolvedTitle,
            mediaType: mediaType,
            posterPath: posterPath,
            backdropPath: backdropPath,
            overview: overview,
            voteAverage: voteAverage,
            releaseDate: releaseDate ?? firstAirDate
        )
    }
}
