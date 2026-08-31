final class SearchUseCase {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String, page: Int) async throws -> MediaPage<MediaItem> {
        try await repository.search(query: query, page: page)
    }
}
