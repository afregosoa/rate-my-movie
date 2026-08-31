protocol WhatsPopularRepositoryProtocol {
    /// Fetches popular content for the given filter.
    func fetchWhatsPopular(filter: WhatsPopularFilter) async throws -> [MediaItem]
}
