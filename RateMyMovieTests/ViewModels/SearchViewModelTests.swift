import Testing
@testable import RateMyMovie

@MainActor
@Suite("SearchViewModel")
struct SearchViewModelTests {

    private func makeViewModel(
        result: Result<MediaPage<MediaItem>, Error> = .success(MediaPage(items: [], totalPages: 1))
    ) -> (SearchViewModel, MockSearchRepository) {
        let repo = MockSearchRepository(result: result)
        let vm = SearchViewModel(useCase: SearchUseCase(repository: repo))
        return (vm, repo)
    }

    // MARK: - Empty / whitespace queries

    @Test func search_emptyQuery_clearsResults() {
        let (vm, _) = makeViewModel()

        vm.search(query: "")

        #expect(vm.results.isEmpty)
    }

    @Test func search_whitespaceQuery_clearsResults() {
        let (vm, _) = makeViewModel()

        vm.search(query: "   ")

        #expect(vm.results.isEmpty)
    }

    // MARK: - Success

    @Test func search_success_populatesResults() async throws {
        let items = [makeMediaItem(id: 1), makeMediaItem(id: 2)]
        let (vm, _) = makeViewModel(result: .success(MediaPage(items: items, totalPages: 1)))

        vm.search(query: "Inception")
        // Wait past the 400ms debounce
        try await Task.sleep(for: .milliseconds(600))

        #expect(vm.results.count == 2)
        #expect(vm.error == nil)
    }

    @Test func search_isLoadingFalseAfterCompletion() async throws {
        let (vm, _) = makeViewModel()

        vm.search(query: "Inception")
        try await Task.sleep(for: .milliseconds(600))

        #expect(vm.isLoading == false)
    }

    // MARK: - Failure

    @Test func search_failure_setsError() async throws {
        let (vm, _) = makeViewModel(result: .failure(TestError.network))

        vm.search(query: "Inception")
        try await Task.sleep(for: .milliseconds(600))

        #expect(vm.error != nil)
        #expect(vm.results.isEmpty)
    }

    // MARK: - Debounce / cancellation

    /// Rapid successive calls should result in only the last query being executed.
    @Test func search_newQuery_cancelsPreviousTask() async throws {
        let (vm, repo) = makeViewModel(result: .success(MediaPage(items: [], totalPages: 1)))

        vm.search(query: "A")   // cancelled immediately by the next call
        vm.search(query: "AB")  // this one fires

        try await Task.sleep(for: .milliseconds(600))

        #expect(repo.callCount == 1)
        #expect(repo.lastQuery == "AB")
    }

    // MARK: - clearError

    @Test func clearError_clearsError() async throws {
        let (vm, _) = makeViewModel(result: .failure(TestError.network))
        vm.search(query: "Inception")
        try await Task.sleep(for: .milliseconds(600))
        #expect(vm.error != nil)

        vm.clearError()

        #expect(vm.error == nil)
    }
}
