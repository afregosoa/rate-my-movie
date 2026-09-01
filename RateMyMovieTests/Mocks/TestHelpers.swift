@testable import RateMyMovie

func makeMovie(id: Int = 1) -> Movie {
    Movie(
        id: id,
        title: "Movie \(id)",
        overview: "Overview \(id)",
        posterPath: nil,
        backdropPath: nil,
        releaseDate: "2024-01-01",
        voteAverage: 7.0,
        voteCount: 100,
        genreIds: [],
        popularity: 10.0
    )
}

func makeMediaItem(id: Int = 1) -> MediaItem {
    MediaItem(
        id: id,
        title: "Show \(id)",
        mediaType: .tv,
        posterPath: nil,
        backdropPath: nil,
        overview: "Overview \(id)",
        voteAverage: 7.0,
        releaseDate: nil
    )
}

enum TestError: Error {
    case network
}
