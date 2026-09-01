@testable import RateMyMovie

final class MockTVShowsRepository: TVShowsRepositoryProtocol {
    var results: [Result<MediaPage<MediaItem>, Error>]
    private(set) var callCount = 0

    init(results: [Result<MediaPage<MediaItem>, Error>] = [.success(MediaPage(items: [], totalPages: 1))]) {
        self.results = results
    }

    func discoverTVShows(page: Int) async throws -> MediaPage<MediaItem> {
        defer { callCount += 1 }
        let index = min(callCount, results.count - 1)
        return try results[index].get()
    }
}
