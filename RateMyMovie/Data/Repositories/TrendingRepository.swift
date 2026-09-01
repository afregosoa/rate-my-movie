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

