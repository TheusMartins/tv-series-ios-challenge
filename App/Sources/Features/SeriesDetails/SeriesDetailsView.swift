//
//  SeriesDetailsView.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 23/04/25.
//

import SwiftUI
import UI

struct SeriesDetailsView: View {
    @StateObject private var viewModel: SeriesDetailsViewModel

    init(seriesID: Int) {
        _viewModel = StateObject(wrappedValue: SeriesDetailsViewModel(seriesID: seriesID))
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            content.padding()
        }
        .onAppear {
            Task {
                await viewModel.fetchDetails()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading Details...")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case .error(let message):
            VStack {
                TVText("Error")
                    .font(.title2)
                TVText(message)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case .success(let model):
            SeriesDetailsContentView(
                uiModel: model,
                availableSeasons: viewModel.availableSeasons,
                selectedSeason: viewModel.selectedSeason,
                episodes: viewModel.filteredEpisodes,
                onSeasonSelected: viewModel.selectSeason
            )
        }
    }
}
