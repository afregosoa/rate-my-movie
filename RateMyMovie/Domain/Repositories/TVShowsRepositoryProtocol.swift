protocol TVShowsRepositoryProtocol {
    /// Fetches a page of discoverable TV shows.
    func discoverTVShows(page: Int) async throws -> MediaPage<MediaItem>
}
