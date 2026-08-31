import Testing
@testable import RateMyMovie

@MainActor
@Suite("DiscoverViewModel")
struct DiscoverViewModelTests {

    // MARK: - loadFirstPage

    @Test func loadFirstPage_success_populatesMovies() async {
        let movies = [makeMovie(id: 1), makeMovie(id: 2)]
        let repo = MockMovieRepository(results: [.success(MediaPage(items: movies, totalPages: 1))])
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))

        await vm.loadFirstPage()

        #expect(vm.movies.count == 2)
        #expect(vm.error == nil)
    }

    @Test func loadFirstPage_setsIsLoadingFalseAfterCompletion() async {
        let repo = MockMovieRepository()
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))

        await vm.loadFirstPage()

        #expect(vm.isLoading == false)
    }

    @Test func loadFirstPage_failure_setsError() async {
        let repo = MockMovieRepository(results: [.failure(TestError.network)])
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))

        await vm.loadFirstPage()

        #expect(vm.error != nil)
        #expect(vm.movies.isEmpty)
    }

    // MARK: - Duplicate filtering

    @Test func loadNextPage_filtersDuplicates() async {
        let page1 = (1...5).map { makeMovie(id: $0) }
        // IDs 3 and 4 appear on both pages — should be deduped
        let page2 = [makeMovie(id: 3), makeMovie(id: 4), makeMovie(id: 6)]
        let repo = MockMovieRepository(results: [
            .success(MediaPage(items: page1, totalPages: 2)),
            .success(MediaPage(items: page2, totalPages: 2))
        ])
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))

        await vm.loadFirstPage()
        await vm.loadNextPageIfNeeded(currentItem: vm.movies[3])

        #expect(vm.movies.count == 6)
    }

    // MARK: - loadNextPageIfNeeded

    @Test func loadNextPageIfNeeded_triggersWhenNearEnd() async {
        let page1 = (1...5).map { makeMovie(id: $0) }
        let repo = MockMovieRepository(results: [
            .success(MediaPage(items: page1, totalPages: 2)),
            .success(MediaPage(items: [makeMovie(id: 6)], totalPages: 2))
        ])
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))

        await vm.loadFirstPage()
        await vm.loadNextPageIfNeeded(currentItem: vm.movies[3]) // index 3 >= count - 3

        #expect(vm.movies.count == 6)
        #expect(repo.callCount == 2)
    }

    @Test func loadNextPageIfNeeded_doesNotTriggerWhenNotNearEnd() async {
        let page1 = (1...5).map { makeMovie(id: $0) }
        let repo = MockMovieRepository(results: [
            .success(MediaPage(items: page1, totalPages: 2))
        ])
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))

        await vm.loadFirstPage()
        await vm.loadNextPageIfNeeded(currentItem: vm.movies[0]) // index 0 < count - 3

        #expect(repo.callCount == 1)
    }

    @Test func loadNextPageIfNeeded_doesNotTriggerWhenNoMorePages() async {
        let page1 = (1...5).map { makeMovie(id: $0) }
        let repo = MockMovieRepository(results: [
            .success(MediaPage(items: page1, totalPages: 1)) // single page
        ])
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))

        await vm.loadFirstPage()
        await vm.loadNextPageIfNeeded(currentItem: vm.movies[4]) // last item

        #expect(repo.callCount == 1)
    }

    // MARK: - clearError

    @Test func clearError_clearsError() async {
        let repo = MockMovieRepository(results: [.failure(TestError.network)])
        let vm = DiscoverViewModel(useCase: DiscoverMoviesUseCase(repository: repo))
        await vm.loadFirstPage()

        vm.clearError()

        #expect(vm.error == nil)
    }
}
