//
//  Strings+Extensions.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import Foundation

extension String {
    var htmlStripped: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        do {
            let attributed = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            return attributed.string
        } catch {
            return self
        }
    }
}
