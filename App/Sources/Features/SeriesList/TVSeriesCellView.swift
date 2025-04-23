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
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: imageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .background(Color(white: 0.95))
                        .cornerRadius(8)
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
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            .clipped()

            VStack(alignment: .leading, spacing: 6) {
                TVText(title, color: .primary)
                    .font(.headline)

                TVText(summary?.strippedHTMLTags ?? "", color: .secondary)
                    .font(.subheadline)
                    .lineLimit(3)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .renderingMode(.template)
                .foregroundColor(TVColors.accent)
                .padding(.top, 4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
