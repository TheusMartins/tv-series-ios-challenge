//
//  DefaultRequester.swift
//  Network
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation

public final class DefaultRequester: Requester {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse {
        guard let request = buildURLRequest(basedOn: infos) else {
            throw RequestError.invalidURL
        }

        do {
            let (data, response) = try await session.data(for: request)
            return .init(data: data, response: response)
        } catch {
            throw RequestError.invalidResponse
        }
    }

    // MARK: - Helpers

    private func buildURLRequest(basedOn infos: RequestInfos) -> URLRequest? {
        guard let baseURL = infos.baseURL,
              var url = URLComponents(string: "\(baseURL)\(infos.endpoint)") else {
            return nil
        }

        infos.parameters?.forEach { key, value in
            url.queryItems = (url.queryItems ?? []) + [URLQueryItem(name: key, value: "\(value)")]
        }

        guard let finalURL = url.url else {
            return nil
        }

        return URLRequest(url: finalURL)
    }
}
