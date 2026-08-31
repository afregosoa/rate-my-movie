@testable import RateMyMovie

final class MockSearchRepository: SearchRepositoryProtocol {
    var result: Result<MediaPage<MediaItem>, Error>
    private(set) var callCount = 0
    private(set) var lastQuery: String?

    init(result: Result<MediaPage<MediaItem>, Error> = .success(MediaPage(items: [], totalPages: 1))) {
        self.result = result
    }

    func search(query: String, page: Int) async throws -> MediaPage<MediaItem> {
        callCount += 1
        lastQuery = query
        return try result.get()
    }
}
