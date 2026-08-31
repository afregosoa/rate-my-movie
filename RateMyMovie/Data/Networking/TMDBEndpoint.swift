import Foundation

enum TMDBEndpoint: Endpoint {
    case discoverMovies(page: Int)
    case discoverTV(page: Int)
    case trending(timeWindow: TimeWindow)
    case freeToWatchMovies
    case freeToWatchTV
    case popularStreaming
    case popularOnTV
    case popularForRent
    case popularInTheaters

    var path: String {
        switch self {
        case .discoverMovies:
            return "/discover/movie"
        case .discoverTV:
            return "/discover/tv"
        case .trending(let timeWindow):
            // TMDB path format: /trending/all/{time_window}
            return "/trending/all/\(timeWindow.rawValue)"
        case .freeToWatchMovies, .popularStreaming, .popularForRent:
            return "/discover/movie"
        case .freeToWatchTV, .popularOnTV:
            return "/discover/tv"
        case .popularInTheaters:
            return "/movie/now_playing"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        switch self {
        case .discoverMovies(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .discoverTV(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .trending:
            // Trending endpoint uses no query parameters; time window is in the path
            return []
        case .freeToWatchMovies, .freeToWatchTV:
            return [
                URLQueryItem(name: "watch_region", value: "US"),
                URLQueryItem(name: "with_watch_monetization_types", value: "free")
            ]
        case .popularStreaming:
            return [
                URLQueryItem(name: "watch_region", value: "US"),
                URLQueryItem(name: "with_watch_monetization_types", value: "flatrate")
            ]
        case .popularOnTV:
            return [
                URLQueryItem(name: "watch_region", value: "US"),
                URLQueryItem(name: "with_watch_monetization_types", value: "flatrate")
            ]
        case .popularForRent:
            return [
                URLQueryItem(name: "watch_region", value: "US"),
                URLQueryItem(name: "with_watch_monetization_types", value: "rent")
            ]
        case .popularInTheaters:
            return []
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
