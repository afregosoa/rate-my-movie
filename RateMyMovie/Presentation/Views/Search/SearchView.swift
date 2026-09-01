import SwiftUI

struct SearchView: View {
    var viewModel: SearchViewModel

    @State private var searchText = ""
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if searchText.isEmpty {
                    emptyPrompt
                } else if viewModel.results.isEmpty {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("No results for \"\(searchText)\"")
                    )
                } else {
                    resultsGrid
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Movies, TV shows...")
            .onChange(of: searchText) { _, newValue in
                viewModel.search(query: newValue)
            }
            .navigationDestination(for: MediaItem.self) { item in
                TVShowDetailView(show: item)
            }
            .alert("Something went wrong", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.clearError() } }
            )) {
                Button("Dismiss", role: .cancel) { viewModel.clearError() }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Subviews

    private var emptyPrompt: some View {
        ContentUnavailableView(
            "Search Movies & TV",
            systemImage: "magnifyingglass",
            description: Text("Find movies and TV shows from the largest entertainment database.")
        )
    }

    private var resultsGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.results) { item in
                    NavigationLink(value: item) {
                        MediaCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}
