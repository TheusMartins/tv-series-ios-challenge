//
//  EpisodeModel.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import Foundation

struct EpisodeModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let summary: String?
    let airdate: String?
    let image: ImageData?

    struct ImageData: Decodable {
        let medium: String?
        let original: String?
    }
}
