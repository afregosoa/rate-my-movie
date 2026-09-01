@testable import RateMyMovie

final class MockTrendingRepository: TrendingRepositoryProtocol {
    var result: Result<[MediaItem], Error>
    private(set) var callCount = 0

    init(result: Result<[MediaItem], Error> = .success([])) {
        self.result = result
    }

    func fetchTrending(timeWindow: TimeWindow) async throws -> [MediaItem] {
        callCount += 1
        return try result.get()
    }
}
