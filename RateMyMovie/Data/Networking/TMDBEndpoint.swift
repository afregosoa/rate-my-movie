import Foundation

enum TMDBEndpoint: Endpoint {
    case discoverMovies(page: Int)
    case trending(timeWindow: TimeWindow)
    case freeToWatchMovies
    case freeToWatchTV

    var path: String {
        switch self {
        case .discoverMovies:
            return "/discover/movie"
        case .trending(let timeWindow):
            // TMDB path format: /trending/all/{time_window}
            return "/trending/all/\(timeWindow.rawValue)"
        case .freeToWatchMovies:
            return "/discover/movie"
        case .freeToWatchTV:
            return "/discover/tv"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        switch self {
        case .discoverMovies(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .trending:
            // Trending endpoint uses no query parameters; time window is in the path
            return []
        case .freeToWatchMovies, .freeToWatchTV:
            // Filter to content with free streaming options in the US
            return [
                URLQueryItem(name: "watch_region", value: "US"),
                URLQueryItem(name: "with_watch_monetization_types", value: "free")
            ]
        }
    }

    // Bearer token and accept header defined once for all TMDB endpoints
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(TMDBConfig.accessToken)",
            "accept": "application/json"
        ]
    }
}
