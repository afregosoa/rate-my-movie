final class FetchWhatsPopularUseCase {
    private let repository: WhatsPopularRepositoryProtocol

    init(repository: WhatsPopularRepositoryProtocol) {
        self.repository = repository
    }

    /// Returns popular items for the given filter.
    func execute(filter: WhatsPopularFilter) async throws -> [MediaItem] {
        try await repository.fetchWhatsPopular(filter: filter)
    }
}
