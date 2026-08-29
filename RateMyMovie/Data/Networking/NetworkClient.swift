import Foundation

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let baseURL: String

    init(session: URLSession = .shared, baseURL: String = TMDBConfig.baseURL) {
        self.session = session
        self.baseURL = baseURL
    }

    func request<T: Decodable>(_ endpoint: some Endpoint) async throws -> T {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
