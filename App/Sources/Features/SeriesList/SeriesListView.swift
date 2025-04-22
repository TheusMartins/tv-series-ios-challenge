//
//  SeriesListView.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import SwiftUI
import UI

public struct SeriesListView: View {
    @StateObject private var viewModel = SeriesListViewModel()

    public init() {}

    public var body: some View {
        content
            .onAppear {
                Task {
                    await viewModel.fetchInitialSeries()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading series...")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case .success(let series):
            List(series, id: \.id) { item in
                VStack(alignment: .leading, spacing: 4) {
                    TVText(item.name)
                        .font(.headline)
                    TVPill(item.name)
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
                .onAppear {
                    Task {
                        await viewModel.fetchNextPageIfNeeded(currentItem: item)
                    }
                }
            }

        case .error(let message):
            VStack(spacing: 12) {
                TVText("Oops!")
                    .font(.title2)
                TVText(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                Button("Retry") {
                    Task {
                        await viewModel.fetchInitialSeries()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}
