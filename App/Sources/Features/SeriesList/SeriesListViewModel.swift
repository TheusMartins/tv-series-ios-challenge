//
//  SeriesListViewModel.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation
import Networking

@MainActor
final class SeriesListViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var state: ViewState<[SeriesListModel]> = .idle
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false

    // MARK: - Private properties

    private let repository: SeriesListRepository
    private var currentPage: Int = 0
    var isFetching = false
    private var hasMorePages = true

    // MARK: - Init

    init(repository: SeriesListRepository = SeriesListRepositoryImplementation()) {
        self.repository = repository
    }

    // MARK: - Public methods

    func fetchInitialSeries() async {
        guard !isFetching else { return }
        state = .loading
        currentPage = 1
        hasMorePages = true
        searchText = ""
        await fetchSeries()
    }

    func fetchNextPageIfNeeded(currentItem: SeriesListModel) async {
        guard hasMorePages,
              !isFetching,
              !isSearching,
              case .success(let items) = state,
              let thresholdIndex = items.index(items.endIndex, offsetBy: -5, limitedBy: items.startIndex),
              items[thresholdIndex].id == currentItem.id else {
            return
        }

        currentPage += 1
        await fetchSeries()
    }
    
    func searchSeries() async {
        guard !searchText.isEmpty else {
            await fetchInitialSeries()
            return
        }

        isSearching = true
        state = .loading

        do {
            let results = try await repository.searchSeries(by: searchText)
            state = .success(results)
        } catch {
            state = .error("Failed to search series.")
        }

        isSearching = false
    }

    // MARK: - Private methods

    private func fetchSeries() async {
        isFetching = true

        do {
            let newItems = try await repository.getSeriesList(page: currentPage)

            if newItems.isEmpty {
                hasMorePages = false
            }

            switch state {
            case .success(let existing) where currentPage > 1:
                state = .success(existing + newItems)
            default:
                state = .success(newItems)
            }

        } catch {
            state = .error("Failed to load series.")
        }

        isFetching = false
    }
}
