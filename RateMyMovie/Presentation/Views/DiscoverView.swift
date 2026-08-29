import SwiftUI

struct DiscoverView: View {
    var viewModel: DiscoverViewModel

    /// Two equal-width columns for the poster grid.
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // Full-screen loader shown only on the first fetch
                    ProgressView()
                } else {
                    movieGrid
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie) // this is the destination
            }
            .navigationTitle("Discover")
            .task {
                // Load page 1 when the view first appears
                await viewModel.loadFirstPage()
            }
            .alert("Something went wrong", isPresented: Binding(
                get: { viewModel.error != nil },
                // Setting isPresented to false dismisses the alert and clears the error
                set: { if !$0 { viewModel.clearError() } }
            )) {
                Button("Retry") {
                    Task { await viewModel.loadFirstPage() }
                }
                Button("Dismiss", role: .cancel) {
                    viewModel.clearError()
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Subviews

    private var movieGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies) { movie in
                    // NavigationLink pushes MovieDetailView when the card is tapped
                    NavigationLink(value: movie) {
                        MovieCardView(movie: movie) // this is the label (what the user taps)
                    }
                    .buttonStyle(.plain)
                    .task {
                        // Each card checks whether it's near the end and triggers pagination
                        await viewModel.loadNextPageIfNeeded(currentItem: movie)
                    }
                }
            }
            .padding()
        }
    }
}
