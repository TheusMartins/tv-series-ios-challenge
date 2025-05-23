//
//  SeriesListRepository.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation
import Networking

protocol SeriesListRepository {
    func getSeriesList(page: Int) async throws -> [SeriesListModel]
    func searchSeries(by name: String) async throws -> [SeriesListModel]
}

final class SeriesListRepositoryImplementation: SeriesListRepository {
    // MARK: - Private properties

    private var requester: Requester

    // MARK: - Initialization

    init(requester: Requester = DefaultRequester()) {
        self.requester = requester
    }

    // MARK: - Open methods

    func getSeriesList(page: Int) async throws -> [SeriesListModel] {
        let response = try await requester.request(basedOn: SeriesRequestInfos.getAll(page: page))
        return try await parseSeriesListResponse(response: response)
    }
    
    func searchSeries(by name: String) async throws -> [SeriesListModel] {
        let response = try await requester.request(basedOn: SeriesRequestInfos.search(query: name))
        return try await parseSearchResponse(response: response)
    }

    // MARK: - Private methods

    private func parseSeriesListResponse(response: RequestSuccessResponse) async throws -> [SeriesListModel] {
        do {
            let model = try JSONDecoder().decode([SeriesListModel].self, from: response.data)
            return model
        } catch {
            throw error
        }
    }
    
    private func parseSearchResponse(response: RequestSuccessResponse) async throws -> [SeriesListModel] {
        do {
            let results = try JSONDecoder().decode([SearchResult].self, from: response.data)
            return results.map(\.show)
        } catch {
            throw error
        }
    }
}
