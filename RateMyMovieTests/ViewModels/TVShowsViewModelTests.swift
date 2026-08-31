import Testing
@testable import RateMyMovie

@MainActor
@Suite("TVShowsViewModel")
struct TVShowsViewModelTests {

    @Test func loadFirstPage_success_populatesShows() async {
        let shows = [makeMediaItem(id: 1), makeMediaItem(id: 2)]
        let repo = MockTVShowsRepository(results: [.success(MediaPage(items: shows, totalPages: 1))])
        let vm = TVShowsViewModel(useCase: DiscoverTVShowsUseCase(repository: repo))

        await vm.loadFirstPage()

        #expect(vm.shows.count == 2)
        #expect(vm.error == nil)
    }

    @Test func loadFirstPage_setsIsLoadingFalseAfterCompletion() async {
        let repo = MockTVShowsRepository()
        let vm = TVShowsViewModel(useCase: DiscoverTVShowsUseCase(repository: repo))

        await vm.loadFirstPage()

        #expect(vm.isLoading == false)
    }

    @Test func loadFirstPage_failure_setsError() async {
        let repo = MockTVShowsRepository(results: [.failure(TestError.network)])
        let vm = TVShowsViewModel(useCase: DiscoverTVShowsUseCase(repository: repo))

        await vm.loadFirstPage()

        #expect(vm.error != nil)
        #expect(vm.shows.isEmpty)
    }

    @Test func loadNextPageIfNeeded_triggersWhenNearEnd() async {
        let page1 = (1...5).map { makeMediaItem(id: $0) }
        let repo = MockTVShowsRepository(results: [
            .success(MediaPage(items: page1, totalPages: 2)),
            .success(MediaPage(items: [makeMediaItem(id: 6)], totalPages: 2))
        ])
        let vm = TVShowsViewModel(useCase: DiscoverTVShowsUseCase(repository: repo))

        await vm.loadFirstPage()
        await vm.loadNextPageIfNeeded(currentItem: vm.shows[3]) // index 3 >= count - 3

        #expect(vm.shows.count == 6)
        #expect(repo.callCount == 2)
    }

    @Test func loadNextPageIfNeeded_doesNotTriggerWhenNotNearEnd() async {
        let page1 = (1...5).map { makeMediaItem(id: $0) }
        let repo = MockTVShowsRepository(results: [
            .success(MediaPage(items: page1, totalPages: 2))
        ])
        let vm = TVShowsViewModel(useCase: DiscoverTVShowsUseCase(repository: repo))

        await vm.loadFirstPage()
        await vm.loadNextPageIfNeeded(currentItem: vm.shows[0]) // index 0 < count - 3

        #expect(repo.callCount == 1)
    }

    @Test func clearError_clearsError() async {
        let repo = MockTVShowsRepository(results: [.failure(TestError.network)])
        let vm = TVShowsViewModel(useCase: DiscoverTVShowsUseCase(repository: repo))
        await vm.loadFirstPage()

        vm.clearError()

        #expect(vm.error == nil)
    }
}
