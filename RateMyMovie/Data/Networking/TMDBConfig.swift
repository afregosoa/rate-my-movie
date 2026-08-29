import Foundation

enum TMDBConfig {
    static var accessToken: String {
        guard let token = Bundle.main.infoDictionary?["TMDB_ACCESS_TOKEN"] as? String,
              !token.isEmpty else {
            fatalError("TMDB_ACCESS_TOKEN missing — assign Config.xcconfig to the target and add the key to Info settings.")
        }
        return token
    }

    static let baseURL = "https://api.themoviedb.org/3"
    /// Used for poster thumbnails in the grid (500px wide).
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    /// Used for full-width backdrop images on the detail screen (780px wide).
    static let backdropBaseURL = "https://image.tmdb.org/t/p/w780"
}
