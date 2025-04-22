//
//  SeriesRequestInfos.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import Networking

enum SeriesRequestInfos {
    case getAll(page: Int)
}

extension SeriesRequestInfos: RequestInfos {
    var endpoint: String {
        switch self {
        case .getAll(let page):
            return "\(String.endpoint)?page=\(page)"
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
    static var endpoint: String {
        return "shows"
    }
}
