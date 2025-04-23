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
                AppTheme.shared.colors.background.ignoresSafeArea()

                VStack(spacing: .listVStackSpacing) {
                    content
                }
                .padding(.horizontal)
            }
            .navigationTitle(String.listTitle)
            .navigationBarTitleDisplayMode(.large)
        }
        .accentColor(AppTheme.shared.colors.accent)
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
            ProgressView(String.loadingMessage)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case .success(let series):
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: .listLazyVStackSpacing) {
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
                .padding(.bottom, .listBottomPadding)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            VStack(spacing: .listErrorSpacing) {
                TVText(.errorTitle)
                    .font(.title2)
                TVText(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                Button(String.retryButton) {
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

// MARK: - Layout Constants

private extension CGFloat {
    static let listVStackSpacing: CGFloat = 16
    static let listLazyVStackSpacing: CGFloat = 16
    static let listBottomPadding: CGFloat = 40
    static let listErrorSpacing: CGFloat = 12
}

// MARK: - UI Strings

private extension String {
    static let listTitle = "Shows"
    static let loadingMessage = "Loading Shows..."
    static let errorTitle = "Oops!"
    static let retryButton = "Retry"
}
