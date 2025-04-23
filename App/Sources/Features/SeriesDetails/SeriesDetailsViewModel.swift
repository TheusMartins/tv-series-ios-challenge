//
//  SeriesDetailsViewModel.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 24/04/25.
//

import Foundation
import Networking

@MainActor
final class SeriesDetailsViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var state: ViewState<SeriesDetailsUIModel> = .idle

    // MARK: - Private properties

    private let repository: SeriesDetailsRepository
    private let seriesID: Int

    // MARK: - Init

    init(
        seriesID: Int,
        repository: SeriesDetailsRepository = SeriesDetailsRepositoryImplementation()
    ) {
        self.seriesID = seriesID
        self.repository = repository
    }

    // MARK: - Public methods

    func fetchDetails() async {
        state = .loading
        print("🐛 Banana: Fetching details for series ID \(seriesID)")

        do {
            let details = try await repository.getSeriesDetails(id: seriesID)
            print("🐛 Banana: Successfully fetched series details")

            if details.type?.lowercased() != .movie {
                print("🐛 Banana: Series is a show. Fetching episodes...")
                let episodes = try await repository.getSeriesEpisodes(id: seriesID)
                print("🐛 Banana: Fetched \(episodes.count) episodes")

                state = .success(SeriesDetailsUIModel(series: details, episodes: episodes))
            } else {
                print("🐛 Banana: Series is a movie. No episodes to fetch.")
                state = .success(SeriesDetailsUIModel(series: details, episodes: nil))
            }

        } catch {
            print("🐛 Banana: Failed to fetch details or episodes: \(error)")
            state = .error("Failed to load details.")
        }
    }
}

// MARK: - UI Model

struct SeriesDetailsUIModel {
    let series: SeriesDetailsModel
    let episodes: [EpisodeModel]?
}

// MARK: - String extension

private extension String {
    static let movie = "movie"
}
