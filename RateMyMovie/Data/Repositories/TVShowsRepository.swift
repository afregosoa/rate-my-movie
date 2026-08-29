import Foundation

final class TVShowsRepository: TVShowsRepositoryProtocol {
    private let service: TMDBServiceProtocol

    init(service: TMDBServiceProtocol) {
        self.service = service
    }

    /// Fetches a page of TV shows and maps DTOs to domain entities.
    func discoverTVShows(page: Int) async throws -> MediaPage<MediaItem> {
        let response = try await service.discoverTVShows(page: page)
        return MediaPage(
            items: response.results.map { $0.toMediaItem() },
            totalPages: response.totalPages
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
