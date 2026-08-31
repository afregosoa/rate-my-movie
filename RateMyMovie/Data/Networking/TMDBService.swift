import Foundation

final class TMDBService: TMDBServiceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func discoverMovies(page: Int) async throws -> DiscoverResponseDTO {
        try await client.request(TMDBEndpoint.discoverMovies(page: page))
    }

    func discoverTVShows(page: Int) async throws -> TVShowResponseDTO {
        try await client.request(TMDBEndpoint.discoverTV(page: page))
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

    func fetchPopularStreaming() async throws -> DiscoverResponseDTO {
        try await client.request(TMDBEndpoint.popularStreaming)
    }

    func fetchPopularOnTV() async throws -> TVShowResponseDTO {
        try await client.request(TMDBEndpoint.popularOnTV)
    }

    func fetchPopularForRent() async throws -> DiscoverResponseDTO {
        try await client.request(TMDBEndpoint.popularForRent)
    }

    func fetchPopularInTheaters() async throws -> DiscoverResponseDTO {
        try await client.request(TMDBEndpoint.popularInTheaters)
    }

    func search(query: String, page: Int) async throws -> TrendingResponseDTO {
        try await client.request(TMDBEndpoint.search(query: query, page: page))
    }
}
