import Foundation

final class TMDBService: TMDBServiceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func discoverMovies(page: Int) async throws -> DiscoverResponseDTO {
        try await client.request(TMDBEndpoint.discoverMovies(page: page))
    }

    func fetchTrending(timeWindow: TimeWindow) async throws -> TrendingResponseDTO {
        try await client.request(TMDBEndpoint.trending(timeWindow: timeWindow))
    }

    func fetchFreeToWatchMovies() async throws -> DiscoverResponseDTO {
        try await client.request(TMDBEndpoint.freeToWatchMovies)
    }

    func fetchFreeToWatchTV() async throws -> TVShowResponseDTO {
        try await client.request(TMDBEndpoint.freeToWatchTV)
    }
}
