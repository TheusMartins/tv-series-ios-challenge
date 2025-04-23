//
//  SeriesDetailsContentView.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import SwiftUI
import UI

struct SeriesDetailsContentView: View {
    let uiModel: SeriesDetailsUIModel
    let availableSeasons: [Int]
    let selectedSeason: Int?
    let episodes: [EpisodeModel]
    let onSeasonSelected: (Int) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = uiModel.series.image?.original,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)

                        case .failure:
                            Color.gray
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                TVText(uiModel.series.name, font: .title, color: .primary)

                if let summary = uiModel.series.summary?.strippedHTMLTags {
                    TVText(summary, font: .body, color: .secondary)
                }

                if !availableSeasons.isEmpty {
                    TVText("Seasons", font: .headline, color: .primary)
                        .padding(.top)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(availableSeasons, id: \.self) { season in
                                TVPill("S\(season)")
                                    .onTapGesture {
                                        onSeasonSelected(season)
                                    }
                                    .opacity(season == selectedSeason ? 1 : 0.5)
                            }
                        }
                    }

                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(episodes, id: \.id) { episode in
                            VStack(alignment: .leading, spacing: 4) {
                                TVText(episode.name, font: .subheadline, color: .primary)

                                if let summary = episode.summary?.strippedHTMLTags {
                                    TVText(summary, font: .body, color: .secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
    }
}
