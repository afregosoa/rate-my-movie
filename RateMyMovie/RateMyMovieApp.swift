import SwiftUI

@main
struct RateMyMovieApp: App {

    /// Composition root — the full dependency graph is wired here and nowhere else.
    /// Each layer receives its dependency via init injection.
    private let discoverViewModel: DiscoverViewModel = {
        let client = NetworkClient()
        let service = TMDBService(client: client)
        let repository = MovieRepository(service: service)
        let useCase = DiscoverMoviesUseCase(repository: repository)
        return DiscoverViewModel(useCase: useCase)
    }()

    var body: some Scene {
        WindowGroup {
            DiscoverView(viewModel: discoverViewModel)
        }
    }
}
