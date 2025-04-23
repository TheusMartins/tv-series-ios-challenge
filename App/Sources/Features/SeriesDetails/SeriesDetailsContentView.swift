//
//  SeriesDetailsContentView.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import SwiftUI
import UI

struct SeriesDetailsContentView: View {
    @State private var selectedEpisode: EpisodeModel?
    
    let uiModel: SeriesDetailsUIModel
    let availableSeasons: [Int]
    let selectedSeason: Int?
    let episodes: [EpisodeModel]
    let onSeasonSelected: (Int) -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: .detailsVStackSpacing) {
                if let imageURL = uiModel.series.image?.original,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: .detailsImageHeight)
                                .frame(maxWidth: .infinity)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: .detailsHStackSpacing))
                                .frame(height: .detailsImageHeight)
                                .frame(maxWidth: .infinity)

                        case .failure:
                            Color.gray
                                .frame(height: .detailsImageHeight)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .detailsHStackSpacing))

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

                    LazyVStack(alignment: .leading, spacing: .detailsLazyVStackSpacing) {
                        ForEach(episodes, id: \.id) { episode in
                            VStack(alignment: .leading, spacing: .detailsEpisodeVPadding) {
                                TVText(episode.name, font: .subheadline, color: .primary)

                                if let summary = episode.summary?.strippedHTMLTags {
                                    TVText(summary, font: .body, color: .secondary)
                                }
                                
                                NavigationLink(
                                    destination: selectedEpisode.map { EpisodeDetailsView(episode: $0) },
                                    isActive: Binding(
                                        get: { selectedEpisode != nil },
                                        set: { isActive in
                                            if !isActive { selectedEpisode = nil }
                                        }
                                    )
                                ) {
                                    EmptyView()
                                }
                                .hidden()
                            }
                            .padding(.vertical, .detailsEpisodeVPadding)
                            .onTapGesture {
                                selectedEpisode = episode
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Layout Constants

private extension CGFloat {
    static let detailsImageHeight: CGFloat = 200
    static let detailsCornerRadius: CGFloat = 8
    static let detailsVStackSpacing: CGFloat = 16
    static let detailsHStackSpacing: CGFloat = 8
    static let detailsLazyVStackSpacing: CGFloat = 12
    static let detailsEpisodeVPadding: CGFloat = 4
}
