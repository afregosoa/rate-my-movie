import Foundation

protocol TMDBServiceProtocol {
    func discoverMovies(page: Int) async throws -> DiscoverResponseDTO
}
