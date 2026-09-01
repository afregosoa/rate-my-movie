@testable import RateMyMovie

final class MockMovieRepository: MovieRepositoryProtocol {
    var results: [Result<MediaPage<Movie>, Error>]
    private(set) var callCount = 0

    init(results: [Result<MediaPage<Movie>, Error>] = [.success(MediaPage(items: [], totalPages: 1))]) {
        self.results = results
    }

    func discoverMovies(page: Int) async throws -> MediaPage<Movie> {
        defer { callCount += 1 }
        let index = min(callCount, results.count - 1)
        return try results[index].get()
    }
}
