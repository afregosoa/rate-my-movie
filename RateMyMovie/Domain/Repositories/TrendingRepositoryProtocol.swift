protocol TrendingRepositoryProtocol {
    /// Fetches the trending items for the given time window.
    func fetchTrending(timeWindow: TimeWindow) async throws -> [MediaItem]
}
