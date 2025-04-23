//
//  TVPill.swift
//  UI
//
//  Created by Matheus Martins on 22/04/25.
//

import SwiftUI

import SwiftUI

public struct TVPill: View {
    private let label: String
    private let color: Color

    public init(_ label: String, color: Color = AppTheme.shared.colors.accent) {
        self.label = label
        self.color = color
    }

    public var body: some View {
        Text(label)
            .font(.caption)
            .padding(.horizontal, .tvPillHorizontalPadding)
            .padding(.vertical, .tvPillVerticalPadding)
            .background(
                RoundedRectangle(cornerRadius: .tvPillCornerRadius)
                    .fill(color.opacity(.tvPillOpacity))
            )
            .foregroundColor(color)
    }
}

#Preview("TVPill - ChibiPew") {
    TVPill("ChibiPew")
}

private extension CGFloat {
    static let tvPillHorizontalPadding: CGFloat = 12
    static let tvPillVerticalPadding: CGFloat = 6
    static let tvPillCornerRadius: CGFloat = 12
}

private extension Double {
    static let tvPillOpacity: Double = 0.2
}
