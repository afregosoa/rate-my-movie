import Foundation

@Observable
final class TVShowsViewModel {

    // MARK: - Public state

    /// TV shows loaded so far across all fetched pages.
    private(set) var shows: [MediaItem] = []

    /// True only during the very first load (no shows on screen yet).
    private(set) var isLoading = false

    /// Holds the last network or decoding error, if any.
    private(set) var error: Error?

    // MARK: - Private state

    private let useCase: DiscoverTVShowsUseCase
    private var currentPage = 1
    private var totalPages = 1

    /// Guards against concurrent fetches when the user scrolls quickly.
    private var isFetching = false

    // MARK: - Init

    init(useCase: DiscoverTVShowsUseCase) {
        self.useCase = useCase
    }

    // MARK: - Public API

    /// Resets state and loads page 1. Call this on first appearance.
    func loadFirstPage() async {
        guard !isFetching else { return }
        currentPage = 1
        shows = []
        await fetchPage(currentPage)
    }

    /// Triggers the next page fetch when the user is near the end of the list.
    /// - Parameter show: The show currently being rendered — used to detect proximity to the last item.
    func loadNextPageIfNeeded(currentItem show: MediaItem) async {
        // Fire when the user reaches the last 3 items and more pages exist
        guard error == nil,
              let index = shows.firstIndex(where: { $0.id == show.id }),
              index >= shows.count - 3,
              currentPage < totalPages,
              !isFetching else { return }
        currentPage += 1
        await fetchPage(currentPage)
    }

    /// Clears the current error, dismissing any presented alert.
    func clearError() {
        error = nil
    }

    // MARK: - Private

    private func fetchPage(_ page: Int) async {
        isFetching = true
        // Show full-screen loader only on the first load; pagination is silent
        isLoading = shows.isEmpty
        defer {
            isFetching = false
            isLoading = false
        }
        do {
            let result = try await useCase.execute(page: page)
            // TMDB can return the same show at page boundaries — filter duplicates before appending
            let newShows = result.items.filter { new in !shows.contains { $0.id == new.id } }
            shows.append(contentsOf: newShows)
            totalPages = result.totalPages
        } catch {
            self.error = error
        }
    }
}
