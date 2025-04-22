//
//  TVPill.swift
//  UI
//
//  Created by Matheus Martins on 22/04/25.
//

import SwiftUI

public struct TVPill: View {
    private let label: String
    private let color: Color

    public init(_ label: String, color: Color = TVColors.accent) {
        self.label = label
        self.color = color
    }

    public var body: some View {
        Text(label)
            .font(.caption)
            .padding(.horizontal, .tv_pillHorizontalPadding)
            .padding(.vertical, .tv_pillVerticalPadding)
            .background(
                RoundedRectangle(cornerRadius: .tv_pillCornerRadius)
                    .fill(color.opacity(.tv_pillOpacity))
            )
            .foregroundColor(color)
    }
}

#Preview("TVPill - ChibiPew") {
    TVPill("ChibiPew")
}
