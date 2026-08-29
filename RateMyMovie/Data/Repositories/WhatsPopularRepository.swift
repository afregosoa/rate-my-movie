import Foundation

final class WhatsPopularRepository: WhatsPopularRepositoryProtocol {
    private let service: TMDBServiceProtocol

    init(service: TMDBServiceProtocol) {
        self.service = service
    }

    /// Fetches popular content and maps DTOs to domain `MediaItem` entities.
    func fetchWhatsPopular(filter: WhatsPopularFilter) async throws -> [MediaItem] {
        switch filter {
        case .streaming:
            let response = try await service.fetchPopularStreaming()
            return response.results.map { $0.toMediaItem() }
        case .onTV:
            let response = try await service.fetchPopularOnTV()
            return response.results.map { $0.toMediaItem() }
        case .forRent:
            let response = try await service.fetchPopularForRent()
            return response.results.map { $0.toMediaItem() }
        case .inTheaters:
            let response = try await service.fetchPopularInTheaters()
            return response.results.map { $0.toMediaItem() }
        }
    }
}

private extension MovieDTO {
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
