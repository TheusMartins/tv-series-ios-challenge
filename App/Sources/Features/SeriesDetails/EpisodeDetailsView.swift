//
//  EpisodeDetailsView.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import SwiftUI
import UI

struct EpisodeDetailsView: View {
    let episode: EpisodeModel

    init(episode: EpisodeModel) {
        self.episode = episode
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .episodeSpacing) {

                if let imageURL = episode.image?.original ?? episode.image?.medium,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: .episodeImageHeight)
                                .frame(maxWidth: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: .episodeCornerRadius))
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Color.gray
                                .frame(height: .episodeImageHeight)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .episodeCornerRadius))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                TVText(episode.name, font: .title, color: .primary)

                TVText("Season \(episode.season), Episode \(episode.number)", font: .subheadline, color: .secondary)

                if let date = episode.airdate {
                    TVText("Aired on: \(date)", font: .caption, color: .secondary)
                }

                if let summary = episode.summary?.strippedHTMLTags {
                    TVText(summary, font: .body, color: .primary)
                }
            }
            .padding()
        }
        .navigationTitle("Episode Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(episode.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Layout Constants

private extension CGFloat {
    static let episodeSpacing: CGFloat = 16
    static let episodeImageHeight: CGFloat = 200
    static let episodeCornerRadius: CGFloat = 8
}

// MARK: - UI Strings

private extension String {
    static func airedOn(_ date: String) -> String {
        "Aired on: \(date)"
    }
}
