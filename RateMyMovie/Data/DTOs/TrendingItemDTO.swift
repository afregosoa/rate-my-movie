import Foundation

/// DTO for a single trending result. Handles mixed movie/TV fields from the same endpoint.
struct TrendingItemDTO: Decodable {
    let id: Int
    let mediaType: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let voteAverage: Double
    let popularity: Double

    // Movie-specific fields
    let title: String?
    let releaseDate: String?

    // TV-specific fields
    let name: String?
    let firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case id, overview, popularity, title, name
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}

extension TrendingItemDTO {
    /// Maps a DTO to a domain `MediaItem`.
    /// Uses `title` for movies and `name` for TV/person, falling back to an empty string.
    func toDomain() -> MediaItem? {
        guard let mediaType = MediaItem.MediaType(rawValue: mediaType) else { return nil }

        let resolvedTitle: String
        switch mediaType {
        case .movie:
            resolvedTitle = title ?? ""
        case .tv, .person:
            resolvedTitle = name ?? ""
        }

        return MediaItem(
            id: id,
            title: resolvedTitle,
            mediaType: mediaType,
            posterPath: posterPath,
            backdropPath: backdropPath,
            overview: overview,
            voteAverage: voteAverage,
            releaseDate: releaseDate ?? firstAirDate
        )
    }
}
