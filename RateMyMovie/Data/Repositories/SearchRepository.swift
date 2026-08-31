import Foundation

final class SearchRepository: SearchRepositoryProtocol {
    private let service: TMDBServiceProtocol

    init(service: TMDBServiceProtocol) {
        self.service = service
    }

    func search(query: String, page: Int) async throws -> MediaPage<MediaItem> {
        let response = try await service.search(query: query, page: page)
        // Person results are filtered out — they require a dedicated detail view
        let items = response.results.compactMap { $0.toDomain() }.filter { $0.mediaType != .person }
        return MediaPage(items: items, totalPages: response.totalPages)
    }
}
