protocol SearchRepositoryProtocol {
    /// Searches for movies and TV shows matching the given query.
    func search(query: String, page: Int) async throws -> MediaPage<MediaItem>
}
