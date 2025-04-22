//
//  Requester.swift
//  Network
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation

public protocol Requester {
    func request(basedOn infos: RequestInfos) async throws -> RequestSuccessResponse
}
