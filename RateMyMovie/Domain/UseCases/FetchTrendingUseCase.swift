final class FetchTrendingUseCase {
    private let repository: TrendingRepositoryProtocol

    init(repository: TrendingRepositoryProtocol) {
        self.repository = repository
    }

    /// Returns trending items for the given time window.
    func execute(timeWindow: TimeWindow) async throws -> [MediaItem] {
        try await repository.fetchTrending(timeWindow: timeWindow)
    }
}
