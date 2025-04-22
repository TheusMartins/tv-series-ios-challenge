//
//  TVText.swift
//  UI
//
//  Created by Matheus Martins on 22/04/25.
//

import SwiftUI

public struct TVText: View {
    private let content: String
    private let font: Font
    private let color: Color

    public init(_ content: String, font: Font = .headline, color: Color = TVColors.primary) {
        self.content = content
        self.font = font
        self.color = color
    }

    public var body: some View {
        Text(content)
            .font(font)
            .foregroundColor(color)
    }
}

#Preview("TVText - ChibiTaxi") {
    TVText("ChibiTaxi")
}
