import Foundation

struct TVShowResponseDTO: Decodable {
    let page: Int
    let results: [TVShowDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
