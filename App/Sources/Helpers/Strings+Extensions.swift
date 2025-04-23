//
//  Strings+Extensions.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import Foundation

import Foundation

extension String {
    /// Removes basic HTML tags using regex — safe and fast.
    var strippedHTMLTags: String {
        let pattern = "<[^>]+>"
        return self.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
    }
}
