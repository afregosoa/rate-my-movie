/// A generic media item (movie, TV show, or person) displayable as a card.
/// Shared across multiple home sections (Trending, Free To Watch, What's Popular).
struct MediaItem: Identifiable, Hashable {
    let id: Int
    /// Resolved from `title` (movie) or `name` (TV/person) at the data layer.
    let title: String
    let mediaType: MediaType
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let voteAverage: Double
    /// Resolved from `release_date` (movie) or `first_air_date` (TV). Nil for person.
    let releaseDate: String?

    enum MediaType: String, Hashable {
        case movie
        case tv
        case person
    }
}
