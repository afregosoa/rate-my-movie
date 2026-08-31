@testable import RateMyMovie

final class MockWhatsPopularRepository: WhatsPopularRepositoryProtocol {
    var result: Result<[MediaItem], Error>
    private(set) var callCount = 0

    init(result: Result<[MediaItem], Error> = .success([])) {
        self.result = result
    }

    func fetchWhatsPopular(filter: WhatsPopularFilter) async throws -> [MediaItem] {
        callCount += 1
        return try result.get()
    }
}
