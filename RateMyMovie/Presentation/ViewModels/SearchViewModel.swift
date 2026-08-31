import Foundation

@Observable
final class SearchViewModel {
    private(set) var results: [MediaItem] = []
    private(set) var isLoading = false
    private(set) var error: Error?

    private let useCase: SearchUseCase
    // Holds the in-flight debounce task so it can be cancelled on each new keystroke
    private var searchTask: Task<Void, Never>?

    init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    /// Called by the view on every keystroke. Waits 400ms before firing the request.
    func search(query: String) {
        searchTask?.cancel()

        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else {
            results = []
            return
        }

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            await performSearch(query: q)
        }
    }

    /// Clears the current error, dismissing any presented alert.
    func clearError() {
        error = nil
    }

    // MARK: - Private

    private func performSearch(query: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let page = try await useCase.execute(query: query, page: 1)
            results = page.items
            error = nil
        } catch {
            guard !(error is CancellationError) else { return }
            self.error = error
        }
    }
}
