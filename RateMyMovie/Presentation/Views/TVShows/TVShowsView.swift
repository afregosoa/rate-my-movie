import SwiftUI

struct TVShowsView: View {
    var viewModel: TVShowsViewModel

    /// Two equal-width columns for the poster grid.
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // Full-screen loader shown only on the first fetch
                    ProgressView()
                } else {
                    showGrid
                }
            }
            .navigationDestination(for: MediaItem.self) { show in
                TVShowDetailView(show: show)
            }
            .navigationTitle("TV Shows")
            .task {
                await viewModel.loadFirstPage()
            }
            .alert("Something went wrong", isPresented: Binding(
                get: { viewModel.error != nil },
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

    private var showGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.shows) { show in
                    // NavigationLink pushes TVShowDetailView when the card is tapped
                    NavigationLink(value: show) {
                        MediaCardView(item: show)
                    }
                    .buttonStyle(.plain)
                    .task {
                        // Each card checks whether it's near the end and triggers pagination
                        await viewModel.loadNextPageIfNeeded(currentItem: show)
                    }
                }
            }
            .padding()
        }
    }
}
