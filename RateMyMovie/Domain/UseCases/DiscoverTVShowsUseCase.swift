final class DiscoverTVShowsUseCase {
    private let repository: TVShowsRepositoryProtocol

    init(repository: TVShowsRepositoryProtocol) {
        self.repository = repository
    }

    /// Returns a page of discoverable TV shows.
    func execute(page: Int) async throws -> MediaPage<MediaItem> {
        try await repository.discoverTVShows(page: page)
    }
}
