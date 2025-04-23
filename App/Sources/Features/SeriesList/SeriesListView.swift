//
//  SeriesListView.swift
//  TVSeriesApp
//
//  Created by Matheus Martins on 22/04/25.
//

import SwiftUI
import UI

struct SeriesListView: View {
    @StateObject private var viewModel = SeriesListViewModel()

    init() {}

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    TVText("Shows", color: .primary)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.top, 24)

                    content
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
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
            ProgressView("Loading Shows...")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case .success(let series):
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(series, id: \.id) { item in
                        NavigationLink(destination: SeriesDetailsView(seriesID: item.id)) {
                            TVSeriesCellView(
                                title: item.name,
                                summary: item.summary?.strippedHTMLTags,
                                imageURL: item.image?.original
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            Task {
                                await viewModel.fetchNextPageIfNeeded(currentItem: item)
                            }
                        }
                    }

                    if viewModel.isFetching {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

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
