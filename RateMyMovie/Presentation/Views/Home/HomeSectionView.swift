import SwiftUI

/// Reusable horizontal section with a title, optional filter chips, and a scrollable carousel.
struct HomeSectionView<Content: View>: View {
    let title: String
    /// Filter option labels. Pass an empty array to hide the filter row.
    let filters: [String]
    @Binding var selectedFilter: String
    /// Carousel items provided by the caller via ViewBuilder.
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)

            // Filter chip row — only rendered when filters are provided
            if !filters.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filters, id: \.self) { filter in
                            filterChip(for: filter)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // Horizontal carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    content()
                }
                .padding(.horizontal)
            }
        }
    }

    /// A single pill-shaped filter button that highlights when selected.
    private func filterChip(for filter: String) -> some View {
        Button {
            selectedFilter = filter
        } label: {
            Text(filter)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                // Filled when selected, outlined when not
                .background(selectedFilter == filter ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(selectedFilter == filter ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
