import Testing
@testable import RateMyMovie

@MainActor
@Suite("HomeViewModel")
struct HomeViewModelTests {

    private func makeViewModel(
        trendingRepo: MockTrendingRepository = MockTrendingRepository(),
        freeToWatchRepo: MockFreeToWatchRepository = MockFreeToWatchRepository(),
        whatsPopularRepo: MockWhatsPopularRepository = MockWhatsPopularRepository()
    ) -> HomeViewModel {
        HomeViewModel(
            fetchTrendingUseCase: FetchTrendingUseCase(repository: trendingRepo),
            fetchFreeToWatchUseCase: FetchFreeToWatchUseCase(repository: freeToWatchRepo),
            fetchWhatsPopularUseCase: FetchWhatsPopularUseCase(repository: whatsPopularRepo)
        )
    }

    // MARK: - Trending

    @Test func loadTrending_success_populatesItems() async {
        let items = [makeMediaItem(id: 1), makeMediaItem(id: 2)]
        let repo = MockTrendingRepository(result: .success(items))
        let vm = makeViewModel(trendingRepo: repo)

        await vm.loadTrending()

        #expect(vm.trendingItems.count == 2)
        #expect(vm.trendingError == nil)
    }

    @Test func loadTrending_skipsIfAlreadyLoaded() async {
        let repo = MockTrendingRepository(result: .success([makeMediaItem(id: 1)]))
        let vm = makeViewModel(trendingRepo: repo)

        await vm.loadTrending()
        await vm.loadTrending() // guard items.isEmpty should skip this

        #expect(repo.callCount == 1)
    }

    @Test func loadTrending_failure_setsError() async {
        let repo = MockTrendingRepository(result: .failure(TestError.network))
        let vm = makeViewModel(trendingRepo: repo)

        await vm.loadTrending()

        #expect(vm.trendingError != nil)
        #expect(vm.trendingItems.isEmpty)
    }

    @Test func selectTrendingWindow_changesWindowAndReloads() async {
        let repo = MockTrendingRepository(result: .success([makeMediaItem(id: 1)]))
        let vm = makeViewModel(trendingRepo: repo)

        await vm.loadTrending()
        await vm.selectTrendingWindow(.week) // different from default .day → should reload

        #expect(vm.selectedTrendingWindow == .week)
        #expect(repo.callCount == 2)
    }

    @Test func selectTrendingWindow_doesNothingIfSameWindow() async {
        let repo = MockTrendingRepository(result: .success([makeMediaItem(id: 1)]))
        let vm = makeViewModel(trendingRepo: repo)

        await vm.selectTrendingWindow(.day) // same as default

        #expect(repo.callCount == 0)
    }

    // MARK: - Free To Watch

    @Test func loadFreeToWatch_success_populatesItems() async {
        let items = [makeMediaItem(id: 1), makeMediaItem(id: 2)]
        let repo = MockFreeToWatchRepository(result: .success(items))
        let vm = makeViewModel(freeToWatchRepo: repo)

        await vm.loadFreeToWatch()

        #expect(vm.freeToWatchItems.count == 2)
        #expect(vm.freeToWatchError == nil)
    }

    @Test func loadFreeToWatch_skipsIfAlreadyLoaded() async {
        let repo = MockFreeToWatchRepository(result: .success([makeMediaItem(id: 1)]))
        let vm = makeViewModel(freeToWatchRepo: repo)

        await vm.loadFreeToWatch()
        await vm.loadFreeToWatch()

        #expect(repo.callCount == 1)
    }

    @Test func loadFreeToWatch_failure_setsError() async {
        let repo = MockFreeToWatchRepository(result: .failure(TestError.network))
        let vm = makeViewModel(freeToWatchRepo: repo)

        await vm.loadFreeToWatch()

        #expect(vm.freeToWatchError != nil)
        #expect(vm.freeToWatchItems.isEmpty)
    }

    @Test func selectFreeToWatchFilter_changesFilterAndReloads() async {
        let repo = MockFreeToWatchRepository(result: .success([makeMediaItem(id: 1)]))
        let vm = makeViewModel(freeToWatchRepo: repo)

        await vm.loadFreeToWatch()
        await vm.selectFreeToWatchFilter(.tv) // change from default .movies

        #expect(vm.selectedFreeToWatchFilter == .tv)
        #expect(repo.callCount == 2)
    }

    // MARK: - What's Popular

    @Test func loadWhatsPopular_success_populatesItems() async {
        let items = [makeMediaItem(id: 1), makeMediaItem(id: 2)]
        let repo = MockWhatsPopularRepository(result: .success(items))
        let vm = makeViewModel(whatsPopularRepo: repo)

        await vm.loadWhatsPopular()

        #expect(vm.whatsPopularItems.count == 2)
        #expect(vm.whatsPopularError == nil)
    }

    @Test func loadWhatsPopular_skipsIfAlreadyLoaded() async {
        let repo = MockWhatsPopularRepository(result: .success([makeMediaItem(id: 1)]))
        let vm = makeViewModel(whatsPopularRepo: repo)

        await vm.loadWhatsPopular()
        await vm.loadWhatsPopular()

        #expect(repo.callCount == 1)
    }

    @Test func loadWhatsPopular_failure_setsError() async {
        let repo = MockWhatsPopularRepository(result: .failure(TestError.network))
        let vm = makeViewModel(whatsPopularRepo: repo)

        await vm.loadWhatsPopular()

        #expect(vm.whatsPopularError != nil)
        #expect(vm.whatsPopularItems.isEmpty)
    }

    @Test func selectWhatsPopularFilter_changesFilterAndReloads() async {
        let repo = MockWhatsPopularRepository(result: .success([makeMediaItem(id: 1)]))
        let vm = makeViewModel(whatsPopularRepo: repo)

        await vm.loadWhatsPopular()
        await vm.selectWhatsPopularFilter(.onTV) // change from default .streaming

        #expect(vm.selectedWhatsPopularFilter == .onTV)
        #expect(repo.callCount == 2)
    }
}
