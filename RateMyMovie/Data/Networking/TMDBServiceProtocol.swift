import Foundation

protocol TMDBServiceProtocol {
    func discoverMovies(page: Int) async throws -> DiscoverResponseDTO
    func discoverTVShows(page: Int) async throws -> TVShowResponseDTO
    func fetchTrending(timeWindow: TimeWindow) async throws -> TrendingResponseDTO
    func fetchFreeToWatchMovies() async throws -> DiscoverResponseDTO
    func fetchFreeToWatchTV() async throws -> TVShowResponseDTO
    func fetchPopularStreaming() async throws -> DiscoverResponseDTO
    func fetchPopularOnTV() async throws -> TVShowResponseDTO
    func fetchPopularForRent() async throws -> DiscoverResponseDTO
    func fetchPopularInTheaters() async throws -> DiscoverResponseDTO
}
