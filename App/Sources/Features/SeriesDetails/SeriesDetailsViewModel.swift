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
    @Published var selectedSeason: Int? {
        didSet {
            updateFilteredEpisodes()
        }
    }
    @Published private(set) var availableSeasons: [Int] = []
    @Published private(set) var filteredEpisodes: [EpisodeModel] = []

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

                let seasons = Set(episodes.map { $0.season }).sorted()
                availableSeasons = seasons
                selectedSeason = seasons.first

                state = .success(SeriesDetailsUIModel(series: details, episodes: episodes))
                updateFilteredEpisodes()

            } else {
                print("🐛 Banana: Series is a movie. No episodes to fetch.")
                state = .success(SeriesDetailsUIModel(series: details, episodes: nil))
                availableSeasons = []
                filteredEpisodes = []
            }

        } catch {
            print("🐛 Banana: Failed to fetch details or episodes: \(error)")
            state = .error("Failed to load details.")
        }
    }

    func selectSeason(_ season: Int) {
        selectedSeason = season
    }

    // MARK: - Private methods

    private func updateFilteredEpisodes() {
        guard case .success(let model) = state,
              let episodes = model.episodes,
              let selected = selectedSeason else {
            filteredEpisodes = []
            return
        }

        filteredEpisodes = episodes.filter { $0.season == selected }
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
