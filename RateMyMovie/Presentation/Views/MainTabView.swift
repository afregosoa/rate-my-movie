import SwiftUI

/// Root tab container. Each tab owns its NavigationStack and dependency graph independently.
struct MainTabView: View {

    /// Instantiated here so each tab's state persists for the app's lifetime.
    @State private var discoverViewModel = DiscoverViewModel(
        useCase: DiscoverMoviesUseCase(
            repository: MovieRepository(
                service: TMDBService(
                    client: NetworkClient()
                )
            )
        )
    )

    @State private var homeViewModel = HomeViewModel(
        fetchTrendingUseCase: FetchTrendingUseCase(
            repository: TrendingRepository(
                service: TMDBService(
                    client: NetworkClient()
                )
            )
        ),
        fetchFreeToWatchUseCase: FetchFreeToWatchUseCase(
            repository: FreeToWatchRepository(
                service: TMDBService(
                    client: NetworkClient()
                )
            )
        )
    )

    var body: some View {
        TabView {
            HomeView(viewModel: homeViewModel)
                .tabItem { Label("Home", systemImage: "house.fill") }

            DiscoverView(viewModel: discoverViewModel)
                .tabItem { Label("Movies", systemImage: "film.fill") }

            TVShowsView()
                .tabItem { Label("TV Shows", systemImage: "tv.fill") }

            PeopleView()
                .tabItem { Label("People", systemImage: "person.2.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
