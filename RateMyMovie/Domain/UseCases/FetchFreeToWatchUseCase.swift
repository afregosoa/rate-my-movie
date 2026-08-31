final class FetchFreeToWatchUseCase {
    private let repository: FreeToWatchRepositoryProtocol

    init(repository: FreeToWatchRepositoryProtocol) {
        self.repository = repository
    }

    /// Returns free-to-watch items for the given media type filter.
    func execute(filter: FreeToWatchFilter) async throws -> [MediaItem] {
        try await repository.fetchFreeToWatch(filter: filter)
    }
}
