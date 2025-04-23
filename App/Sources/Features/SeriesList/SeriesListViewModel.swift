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
        await fetchSeries()
    }

    func fetchNextPageIfNeeded(currentItem: SeriesListModel) async {
        guard hasMorePages,
              !isFetching,
              case .success(let items) = state,
              let thresholdIndex = items.index(items.endIndex, offsetBy: -5, limitedBy: items.startIndex),
              items[thresholdIndex].id == currentItem.id else {
            return
        }

        print("🐛 Banana: Triggering pagination for page \(currentPage + 1) due to item: \(currentItem.id)")
        currentPage += 1
        await fetchSeries()
    }

    // MARK: - Private methods

    private func fetchSeries() async {
        isFetching = true
        print("🐛 Banana: Fetching page \(currentPage)")

        do {
            let newItems = try await repository.getSeriesList(page: currentPage)
            print("🐛 Banana: Received \(newItems.count) items on page \(currentPage)")

            if newItems.isEmpty {
                print("🐛 Banana: No more items. Stopping pagination.")
                hasMorePages = false
            }

            switch state {
            case .success(let existing) where currentPage > 1:
                print("🐛 Banana: Appending to existing list (now total: \(existing.count + newItems.count))")
                state = .success(existing + newItems)
            default:
                print("🐛 Banana: Initializing new list with \(newItems.count) items")
                state = .success(newItems)
            }

        } catch {
            print("🐛 Banana: Failed to fetch series: \(error)")
            state = .error("Failed to load series.")
        }

        isFetching = false
    }
}
