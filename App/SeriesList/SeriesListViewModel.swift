//
//  SeriesListViewModel.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation
import Networking

@MainActor
public final class SeriesListViewModel: ObservableObject {

    // MARK: - Published properties

    @Published public private(set) var state: ViewState<[SeriesModel]> = .idle

    // MARK: - Private properties

    private let repository: SeriesListRepository
    private var currentPage: Int = 0
    private var isFetching = false

    // MARK: - Init

    public init(repository: SeriesListRepository = SeriesListRepositoryImplementation()) {
        self.repository = repository
    }

    // MARK: - Public methods

    public func fetchInitialSeries() async {
        state = .loading
        currentPage = 0
        await fetchSeries(page: currentPage, reset: true)
    }

    public func fetchNextPage() async {
        guard !isFetching else { return }
        isFetching = true
        currentPage += 1
        await fetchSeries(page: currentPage, reset: false)
    }

    // MARK: - Private methods

    private func fetchSeries(page: Int, reset: Bool) async {
        do {
            let result = try await repository.getSeries(page: page)
            let newList = result.results

            switch state {
            case .success(let existing) where !reset:
                state = .success(existing + newList)
            default:
                state = .success(newList)
            }

        } catch {
            state = .error("Failed to load series.")
        }

        isFetching = false
    }
}
