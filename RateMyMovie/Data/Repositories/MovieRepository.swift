import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let service: TMDBServiceProtocol

    init(service: TMDBServiceProtocol = TMDBService()) {
        self.service = service
    }

    func discoverMovies(page: Int) async throws -> MediaPage<Movie> {
        let response = try await service.discoverMovies(page: page)
        return MediaPage(
            items: response.results.map(\.movie),
            totalPages: response.totalPages
        )
    }
}

private extension MovieDTO {
    var movie: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            genreIds: genreIds,
            popularity: popularity
        )
    }
}
