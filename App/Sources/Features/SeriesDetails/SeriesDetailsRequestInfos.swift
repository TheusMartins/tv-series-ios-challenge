//
//  SeriesDetailsRequestInfos.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import Networking

enum SeriesDetailsRequestInfos {
    case getDetails(id: Int)
    case getEpisodes(id: Int)
}

extension SeriesDetailsRequestInfos: RequestInfos {
    var endpoint: String {
        switch self {
        case .getDetails(let id):
            return "\(String.basePath)/\(id)"
        case .getEpisodes(let id):
            return "\(String.basePath)/\(id)/episodes"
        }
    }

    var method: Networking.HTTPMethod {
        .get
    }

    var parameters: [String: Any]? {
        nil
    }
}

private extension String {
    static var basePath: String {
        return "shows"
    }
}
