final class DiscoverMoviesUseCase {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> DiscoverPage {
        try await repository.discoverMovies(page: page)
    }
}
