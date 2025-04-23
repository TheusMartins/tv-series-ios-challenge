//
//  SeriesListModel.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import Foundation

struct SeriesListModel: Decodable {
    let id: Int
    let name: String
    let image: ImageModel?
    let summary: String?
}

struct ImageModel: Decodable {
    let medium: String?
    let original: String?
}

struct SearchResult: Decodable {
    let score: Double?
    let show: SeriesListModel
}
