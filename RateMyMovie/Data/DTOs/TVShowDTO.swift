import Foundation

/// DTO for a TV show result from list endpoints (e.g. discover/tv).
/// Uses `name` and `first_air_date` instead of the movie equivalents.
struct TVShowDTO: Decodable {
    let id: Int
    let name: String
    let firstAirDate: String?
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
    }
}
