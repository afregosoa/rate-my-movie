import Foundation

protocol TMDBServiceProtocol {
    func discoverMovies(page: Int) async throws -> DiscoverResponseDTO
    func fetchTrending(timeWindow: TimeWindow) async throws -> TrendingResponseDTO
    func fetchFreeToWatchMovies() async throws -> DiscoverResponseDTO
    func fetchFreeToWatchTV() async throws -> TVShowResponseDTO
}
