//
//  SeriesDetailsModel.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import Foundation

struct SeriesDetailsModel: Decodable {
    let id: Int
    let name: String
    let summary: String?
    let genres: [String]?
    let image: ImageData?
    let type: String? 

    struct ImageData: Decodable {
        let medium: String?
        let original: String?
    }
}
