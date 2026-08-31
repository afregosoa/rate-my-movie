import SwiftUI

struct HomeView: View {
    var viewModel: HomeViewModel

    /// Search query — wired to the search bar, will drive SearchView later.
    @State private var searchQuery = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    trendingSection
                    whatsPopularSection
                    freeToWatchSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .searchable(text: $searchQuery, prompt: "Search movies, TV shows, people…")
            .task {
                async let trending: () = viewModel.loadTrending()
                async let freeToWatch: () = viewModel.loadFreeToWatch()
                async let whatsPopular: () = viewModel.loadWhatsPopular()
                _ = await (trending, freeToWatch, whatsPopular)
            }
            .alert("Failed to load trending", isPresented: Binding(
                get: { viewModel.trendingError != nil },
                set: { if !$0 { viewModel.clearTrendingError() } }
            )) {
                Button("Retry") { Task { await viewModel.loadTrending() } }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(viewModel.trendingError?.localizedDescription ?? "")
            }
            .alert("Failed to load free to watch", isPresented: Binding(
                get: { viewModel.freeToWatchError != nil },
                set: { if !$0 { viewModel.clearFreeToWatchError() } }
            )) {
                Button("Retry") { Task { await viewModel.loadFreeToWatch() } }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(viewModel.freeToWatchError?.localizedDescription ?? "")
            }
            .alert("Failed to load what's popular", isPresented: Binding(
                get: { viewModel.whatsPopularError != nil },
                set: { if !$0 { viewModel.clearWhatsPopularError() } }
            )) {
                Button("Retry") { Task { await viewModel.loadWhatsPopular() } }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(viewModel.whatsPopularError?.localizedDescription ?? "")
            }
        }
    }

    // MARK: - Sections

    private var trendingSection: some View {
        // Bridge TimeWindow enum to the String-based filter chip UI
        let trendingFilterBinding = Binding<String>(
            get: { viewModel.selectedTrendingWindow == .day ? "Today" : "This Week" },
            set: { newValue in
                let window: TimeWindow = newValue == "Today" ? .day : .week
                Task { await viewModel.selectTrendingWindow(window) }
            }
        )

        return HomeSectionView(
            title: "Trending",
            filters: ["Today", "This Week"],
            selectedFilter: trendingFilterBinding
        ) {
            if viewModel.isLoadingTrending {
                // Show skeleton cards while the first fetch is in progress
                ForEach(0..<10, id: \.self) { _ in PlaceholderCard() }
            } else {
                ForEach(viewModel.trendingItems) { item in
                    MediaCardView(item: item)
                }
            }
        }
    }

    private var whatsPopularSection: some View {
        // Bridge WhatsPopularFilter enum to the String-based filter chip UI
        let filterBinding = Binding<String>(
            get: {
                switch viewModel.selectedWhatsPopularFilter {
                case .streaming: return "Streaming"
                case .onTV: return "On TV"
                case .forRent: return "For Rent"
                case .inTheaters: return "In Theaters"
                }
            },
            set: { newValue in
                let filter: WhatsPopularFilter
                switch newValue {
                case "On TV": filter = .onTV
                case "For Rent": filter = .forRent
                case "In Theaters": filter = .inTheaters
                default: filter = .streaming
                }
                Task { await viewModel.selectWhatsPopularFilter(filter) }
            }
        )

        return HomeSectionView(
            title: "What's Popular",
            filters: ["Streaming", "On TV", "For Rent", "In Theaters"],
            selectedFilter: filterBinding
        ) {
            if viewModel.isLoadingWhatsPopular {
                // Show skeleton cards while the first fetch is in progress
                ForEach(0..<10, id: \.self) { _ in PlaceholderCard() }
            } else {
                ForEach(viewModel.whatsPopularItems) { item in
                    MediaCardView(item: item)
                }
            }
        }
    }

    private var freeToWatchSection: some View {
        // Bridge FreeToWatchFilter enum to the String-based filter chip UI
        let filterBinding = Binding<String>(
            get: { viewModel.selectedFreeToWatchFilter == .movies ? "Movies" : "TV" },
            set: { newValue in
                let filter: FreeToWatchFilter = newValue == "Movies" ? .movies : .tv
                Task { await viewModel.selectFreeToWatchFilter(filter) }
            }
        )

        return HomeSectionView(
            title: "Free To Watch",
            filters: ["Movies", "TV"],
            selectedFilter: filterBinding
        ) {
            if viewModel.isLoadingFreeToWatch {
                // Show skeleton cards while the first fetch is in progress
                ForEach(0..<10, id: \.self) { _ in PlaceholderCard() }
            } else {
                ForEach(viewModel.freeToWatchItems) { item in
                    MediaCardView(item: item)
                }
            }
        }
    }
}

// MARK: - Placeholder card

/// Temporary card shown before API data is wired in.
private struct PlaceholderCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.secondarySystemBackground))
            .frame(width: 140, height: 210)
            .overlay {
                Image(systemName: "film")
                    .font(.largeTitle)
                    .foregroundStyle(.tertiary)
            }
    }
}
