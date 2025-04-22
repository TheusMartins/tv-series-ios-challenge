//
//  RequestInfos.swift
//  Network
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation

public protocol RequestInfos {
    var baseURL: URL? { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

public extension RequestInfos {
    var baseURL: URL? {
        return URL(string: "https://api.tvmaze.com/")!
    }
}
