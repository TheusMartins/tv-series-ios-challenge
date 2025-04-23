//
//  SeriesDetailsRepository.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import Foundation
import Networking

protocol SeriesDetailsRepository {
    func getSeriesDetails(id: Int) async throws -> SeriesDetailsModel
    func getSeriesEpisodes(id: Int) async throws -> [EpisodeModel]
}

final class SeriesDetailsRepositoryImplementation: SeriesDetailsRepository {
    // MARK: - Private properties

    private var requester: Requester

    // MARK: - Initialization

    init(requester: Requester = DefaultRequester()) {
        self.requester = requester
    }

    // MARK: - Open methods

    func getSeriesDetails(id: Int) async throws -> SeriesDetailsModel {
        let response = try await requester.request(basedOn: SeriesDetailsRequestInfos.getDetails(id: id))
        return try await parseDetailsResponse(response: response)
    }

    func getSeriesEpisodes(id: Int) async throws -> [EpisodeModel] {
        let response = try await requester.request(basedOn: SeriesDetailsRequestInfos.getEpisodes(id: id))
        return try await parseEpisodesResponse(response: response)
    }

    // MARK: - Private methods

    private func parseDetailsResponse(response: RequestSuccessResponse) async throws -> SeriesDetailsModel {
        do {
            return try JSONDecoder().decode(SeriesDetailsModel.self, from: response.data)
        } catch {
            throw error
        }
    }

    private func parseEpisodesResponse(response: RequestSuccessResponse) async throws -> [EpisodeModel] {
        do {
            return try JSONDecoder().decode([EpisodeModel].self, from: response.data)
        } catch {
            throw error
        }
    }
}
