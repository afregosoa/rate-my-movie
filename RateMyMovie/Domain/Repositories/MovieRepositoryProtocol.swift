struct DiscoverPage {
    let movies: [Movie]
    let totalPages: Int
}

protocol MovieRepositoryProtocol {
    func discoverMovies(page: Int) async throws -> DiscoverPage
}
