//
//  RequestError.swift
//  Network
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation

public enum RequestError: Error, Equatable {
    case invalidResponse
    case invalidURL
}
