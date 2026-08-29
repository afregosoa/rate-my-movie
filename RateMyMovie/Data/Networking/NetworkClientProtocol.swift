import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: some Endpoint) async throws -> T
}

