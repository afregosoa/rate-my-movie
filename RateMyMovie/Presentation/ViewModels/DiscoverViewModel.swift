import Foundation

@Observable
final class DiscoverViewModel {

    // MARK: - Public state

    /// Movies loaded so far across all fetched pages.
    private(set) var movies: [Movie] = []

    /// True only during the very first load (no movies on screen yet).
    private(set) var isLoading = false

    /// Holds the last network or decoding error, if any.
    private(set) var error: Error?

    // MARK: - Private state

    private let useCase: DiscoverMoviesUseCase
    private var currentPage = 1
    private var totalPages = 1

    /// Guards against concurrent fetches when the user scrolls quickly.
    private var isFetching = false

    // MARK: - Init

    init(useCase: DiscoverMoviesUseCase) {
        self.useCase = useCase
    }

    // MARK: - Public API

    /// Resets state and loads page 1. Call this on first appearance.
    func loadFirstPage() async {
        guard !isFetching else { return }
        currentPage = 1
        movies = []
        await fetchPage(currentPage)
    }

    /// Triggers the next page fetch when the user is near the end of the list.
    /// - Parameter movie: The movie currently being rendered — used to detect proximity to the last item.
    func loadNextPageIfNeeded(currentItem movie: Movie) async {
        // Fire when the user reaches the last 3 items and more pages exist
        // Stop paginating if there's an active error — prevents race condition where
        // multiple cards fire simultaneously and keep overwriting the error state
        guard error == nil,
              let index = movies.firstIndex(where: { $0.id == movie.id }),
              index >= movies.count - 3,
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
        isLoading = movies.isEmpty
        defer {
            isFetching = false
            isLoading = false
        }
        do {
            let result = try await useCase.execute(page: page)
            // TMDB can return the same movie at page boundaries — filter duplicates before appending
            let newMovies = result.movies.filter { new in !movies.contains { $0.id == new.id } }
            movies.append(contentsOf: newMovies)
            totalPages = result.totalPages
        } catch {
            self.error = error
        }
    }
}
