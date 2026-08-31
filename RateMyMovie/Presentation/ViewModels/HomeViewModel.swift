import Foundation

@Observable
final class HomeViewModel {
    // MARK: - Trending state
    private(set) var trendingItems: [MediaItem] = []
    private(set) var isLoadingTrending = false
    private(set) var trendingError: Error?
    private(set) var selectedTrendingWindow: TimeWindow = .day

    // MARK: - Free To Watch state
    private(set) var freeToWatchItems: [MediaItem] = []
    private(set) var isLoadingFreeToWatch = false
    private(set) var freeToWatchError: Error?
    private(set) var selectedFreeToWatchFilter: FreeToWatchFilter = .movies

    // MARK: - What's Popular state
    private(set) var whatsPopularItems: [MediaItem] = []
    private(set) var isLoadingWhatsPopular = false
    private(set) var whatsPopularError: Error?
    private(set) var selectedWhatsPopularFilter: WhatsPopularFilter = .streaming

    private let fetchTrendingUseCase: FetchTrendingUseCase
    private let fetchFreeToWatchUseCase: FetchFreeToWatchUseCase
    private let fetchWhatsPopularUseCase: FetchWhatsPopularUseCase

    init(
        fetchTrendingUseCase: FetchTrendingUseCase,
        fetchFreeToWatchUseCase: FetchFreeToWatchUseCase,
        fetchWhatsPopularUseCase: FetchWhatsPopularUseCase
    ) {
        self.fetchTrendingUseCase = fetchTrendingUseCase
        self.fetchFreeToWatchUseCase = fetchFreeToWatchUseCase
        self.fetchWhatsPopularUseCase = fetchWhatsPopularUseCase
    }

    // MARK: - Trending

    /// Loads trending items for the currently selected time window.
    /// Skips the fetch if data is already loaded — prevents duplicate requests on tab re-appearance.
    func loadTrending() async {
        guard trendingItems.isEmpty else { return }
        guard !isLoadingTrending else { return }
        isLoadingTrending = true
        defer { isLoadingTrending = false }

        do {
            trendingItems = try await fetchTrendingUseCase.execute(timeWindow: selectedTrendingWindow)
            trendingError = nil
        } catch {
            trendingError = error
        }
    }

    /// Switches the time window filter and reloads trending items.
    func selectTrendingWindow(_ window: TimeWindow) async {
        guard window != selectedTrendingWindow else { return }
        selectedTrendingWindow = window
        trendingItems = []
        await loadTrending()
    }

    func clearTrendingError() {
        trendingError = nil
    }

    // MARK: - Free To Watch

    /// Loads free-to-watch content for the currently selected media type filter.
    /// Skips the fetch if data is already loaded — prevents duplicate requests on tab re-appearance.
    func loadFreeToWatch() async {
        guard freeToWatchItems.isEmpty else { return }
        guard !isLoadingFreeToWatch else { return }
        isLoadingFreeToWatch = true
        defer { isLoadingFreeToWatch = false }

        do {
            freeToWatchItems = try await fetchFreeToWatchUseCase.execute(filter: selectedFreeToWatchFilter)
            freeToWatchError = nil
        } catch {
            freeToWatchError = error
        }
    }

    /// Switches the media type filter and reloads free-to-watch content.
    func selectFreeToWatchFilter(_ filter: FreeToWatchFilter) async {
        guard filter != selectedFreeToWatchFilter else { return }
        selectedFreeToWatchFilter = filter
        freeToWatchItems = []
        await loadFreeToWatch()
    }

    func clearFreeToWatchError() {
        freeToWatchError = nil
    }

    // MARK: - What's Popular

    /// Loads popular content for the currently selected filter.
    /// Skips the fetch if data is already loaded — prevents duplicate requests on tab re-appearance.
    func loadWhatsPopular() async {
        guard whatsPopularItems.isEmpty else { return }
        guard !isLoadingWhatsPopular else { return }
        isLoadingWhatsPopular = true
        defer { isLoadingWhatsPopular = false }

        do {
            whatsPopularItems = try await fetchWhatsPopularUseCase.execute(filter: selectedWhatsPopularFilter)
            whatsPopularError = nil
        } catch {
            whatsPopularError = error
        }
    }

    /// Switches the filter and reloads What's Popular content.
    func selectWhatsPopularFilter(_ filter: WhatsPopularFilter) async {
        guard filter != selectedWhatsPopularFilter else { return }
        selectedWhatsPopularFilter = filter
        whatsPopularItems = []
        await loadWhatsPopular()
    }

    func clearWhatsPopularError() {
        whatsPopularError = nil
    }
}
