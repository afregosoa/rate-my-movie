import Foundation

enum TMDBEndpoint: Endpoint {
    case discoverMovies(page: Int)

    var path: String {
        switch self {
        case .discoverMovies: return "/discover/movie"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        switch self {
        case .discoverMovies(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
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
