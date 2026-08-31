/// A single page of paged media results.
/// Generic over `Item` so it can carry `Movie`, `MediaItem`, or any future entity.
struct MediaPage<Item> {
    let items: [Item]
    let totalPages: Int
}
