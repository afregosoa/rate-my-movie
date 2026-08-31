protocol FreeToWatchRepositoryProtocol {
    /// Fetches free-to-watch content for the given media type filter.
    func fetchFreeToWatch(filter: FreeToWatchFilter) async throws -> [MediaItem]
}
