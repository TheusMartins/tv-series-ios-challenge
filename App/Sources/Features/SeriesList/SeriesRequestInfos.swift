//
//  SeriesRequestInfos.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import Networking

enum SeriesRequestInfos {
    case getAll(page: Int)
    case search(query: String)
}

extension SeriesRequestInfos: RequestInfos {
    var endpoint: String {
        switch self {
        case .getAll(let page):
            return "\(String.endpoint)?page=\(page)"
        case .search:
            return String.searchEndpoint
        }
    }

    var method: Networking.HTTPMethod {
        .get
    }

    var parameters: [String: Any]? {
        switch self {
        case .getAll:
            return nil
        case .search(let query):
            return ["q": query]
        }
    }
}

private extension String {
    static var endpoint: String { "shows" }
    static var searchEndpoint: String { "search/shows" }
}
