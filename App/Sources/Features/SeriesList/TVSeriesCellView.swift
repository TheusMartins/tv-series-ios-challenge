//
//  TVSeriesCellView.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import SwiftUI
import UI

struct TVSeriesCellView: View {
    let title: String
    let summary: String?
    let imageURL: String?

    var body: some View {
        HStack(alignment: .top, spacing: .cellPadding) {
            AsyncImage(url: URL(string: imageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: .cellImageSize, height: .cellImageSize)
                        .background(Color.cellImagePlaceholder)
                        .cornerRadius(.cellImagePlaceholderCornerRadius)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.gray
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: .cellImageSize, height: .cellImageSize)
            .cornerRadius(.cellImageCornerRadius)
            .clipped()

            VStack(alignment: .leading, spacing: .cellVStackSpacing) {
                TVText(title, color: .primary)
                    .font(.headline)

                TVText(summary?.strippedHTMLTags ?? "", color: .secondary)
                    .font(.subheadline)
                    .lineLimit(3)
            }

            Spacer(minLength: .cellSpacerMinLength)

            Image(systemName: .chevronIcon)
                .renderingMode(.template)
                .foregroundColor(AppTheme.shared.colors.accent)
                .padding(.top, .cellChevronPaddingTop)
        }
        .padding()
        .background(AppTheme.shared.colors.background)
        .cornerRadius(12)
        .shadow(color: .cellShadowColor, radius: .cellShadowRadius, x: .zero, y: .cellShadowYOffset)
    }
}

// MARK: - Layout Constants

private extension CGFloat {
    static let cellImageSize: CGFloat = 80
    static let cellImageCornerRadius: CGFloat = 10
    static let cellImagePlaceholderCornerRadius: CGFloat = 8
    static let cellVStackSpacing: CGFloat = 6
    static let cellChevronPaddingTop: CGFloat = 4
    static let cellSpacerMinLength: CGFloat = 8
    static let cellPadding: CGFloat = 16
    static let cellCornerRadius: CGFloat = 12
    static let cellShadowRadius: CGFloat = 4
    static let cellShadowYOffset: CGFloat = 2
}

// MARK: - Color Constants

private extension Color {
    static let cellImagePlaceholder = Color(white: 0.95)
    static let cellShadowColor = Color.black.opacity(0.05)
}

private extension String {
    static let chevronIcon = "chevron.right"
}
