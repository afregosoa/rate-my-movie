protocol MovieRepositoryProtocol {
    func discoverMovies(page: Int) async throws -> MediaPage<Movie>
}
