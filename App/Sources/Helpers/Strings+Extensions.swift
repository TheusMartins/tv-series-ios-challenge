//
//  Strings+Extensions.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import Foundation

extension String {
    var htmlStripped: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return self // fallback if HTML parsing fails
        }
    }
}
