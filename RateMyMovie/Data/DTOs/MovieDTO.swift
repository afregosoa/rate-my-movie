import Foundation

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let genreIds: [Int]
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
    }
}
