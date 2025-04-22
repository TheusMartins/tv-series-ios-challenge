//
//  RequestSuccessResponse.swift
//  Network
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation

public struct RequestSuccessResponse {
    public let data: Data
    public let response: URLResponse

    public init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
}
