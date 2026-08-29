import Foundation

final class TMDBService: TMDBServiceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func discoverMovies(page: Int) async throws -> DiscoverResponseDTO {
        try await client.request(TMDBEndpoint.discoverMovies(page: page))
    }
}
