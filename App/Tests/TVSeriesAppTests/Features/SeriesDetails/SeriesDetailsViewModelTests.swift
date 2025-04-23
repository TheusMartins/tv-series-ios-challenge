//
//  SeriesDetailsViewModelTests.swift
//  TVSeriesAppTests
//
//  Created by Matheus Martins on 25/04/25.
//

import Combine
import XCTest
@testable import TVSeriesApp

@MainActor
final class SeriesDetailsViewModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: SeriesDetailsViewModel, spy: SeriesDetailsRepositorySpy) {
        let spy = SeriesDetailsRepositorySpy()
        let sut = SeriesDetailsViewModel(seriesID: 1, repository: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        return (sut, spy)
    }

    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak", file: file, line: line)
        }
    }

    // MARK: - Tests

    func test_onInit_stateShouldBeIdle() {
        let (sut, _) = makeSUT()

        switch sut.state {
        case .idle:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected state to be .idle")
        }
    }

    func test_fetchDetails_withEpisodes_shouldSetStateToSuccess() async {
        let (sut, spy) = makeSUT()
        spy.detailsResult = .success(.mock())
        spy.episodesResult = .success([.mock(season: 1), .mock(season: 2)])

        await sut.fetchDetails()

        switch sut.state {
        case .success(let model):
            XCTAssertEqual(model.series.name, "Mock Series")
            XCTAssertEqual(model.episodes?.count, 2)
            XCTAssertEqual(sut.availableSeasons, [1, 2])
            XCTAssertEqual(sut.filteredEpisodes.count, 1)
        default:
            XCTFail("Expected success state")
        }
    }

    func test_fetchDetails_withoutEpisodes_shouldSetEmptyState() async {
        let (sut, spy) = makeSUT()
        spy.detailsResult = .success(.mock(type: "movie"))

        await sut.fetchDetails()

        switch sut.state {
        case .success(let model):
            XCTAssertNil(model.episodes)
            XCTAssertTrue(sut.availableSeasons.isEmpty)
            XCTAssertTrue(sut.filteredEpisodes.isEmpty)
        default:
            XCTFail("Expected success state for movie")
        }
    }

    func test_fetchDetails_failure_shouldSetErrorState() async {
        let (sut, spy) = makeSUT()
        spy.detailsResult = .failure(NSError(domain: "Test", code: 1))

        await sut.fetchDetails()

        switch sut.state {
        case .error(let message):
            XCTAssertEqual(message, "Failed to load details.")
        default:
            XCTFail("Expected error state with message")
        }
    }

    func test_selectSeason_shouldUpdateFilteredEpisodes() async {
        let (sut, spy) = makeSUT()
        spy.detailsResult = .success(.mock())
        spy.episodesResult = .success([
            .mock(id: 1, season: 1),
            .mock(id: 2, season: 2),
            .mock(id: 3, season: 2)
        ])

        await sut.fetchDetails()
        sut.selectSeason(2)

        XCTAssertEqual(sut.filteredEpisodes.count, 2)
        XCTAssertTrue(sut.filteredEpisodes.allSatisfy { $0.season == 2 })
    }

    func test_fetchDetails_shouldEmitLoadingBeforeSuccess() async {
        let (sut, spy) = makeSUT()
        spy.detailsResult = .success(.mock())
        spy.episodesResult = .success([.mock()])
        let observer = ViewStateSpy(publisher: sut.$state)

        await sut.fetchDetails()

        XCTAssertTrue(observer.values.contains {
            if case .loading = $0 { return true } else { return false }
        }, "Expected to emit .loading before final state.")
    }
    
    func test_fetchDetails_shouldEmitLoadingBeforeError() async {
        // Given
        let (sut, spy) = makeSUT()
        spy.detailsResult = .failure(NSError(domain: "Test", code: 99))
        let observer = ViewStateSpy(publisher: sut.$state)

        // When
        await sut.fetchDetails()

        // Then
        let containsLoading = observer.values.contains {
            if case .loading = $0 { return true } else { return false }
        }

        XCTAssertTrue(containsLoading, "Expected to emit .loading before error state.")
        
        if case .error(let message)? = observer.values.last {
            XCTAssertEqual(message, "Failed to load details.")
        } else {
            XCTFail("Expected final state to be .error")
        }
    }
}

// MARK: - Spy

final class SeriesDetailsRepositorySpy: SeriesDetailsRepository {
    var detailsResult: Result<SeriesDetailsModel, Error> = .success(.mock())
    var episodesResult: Result<[EpisodeModel], Error> = .success([])

    func getSeriesDetails(id: Int) async throws -> SeriesDetailsModel {
        return try detailsResult.get()
    }

    func getSeriesEpisodes(id: Int) async throws -> [EpisodeModel] {
        return try episodesResult.get()
    }
}

// MARK: - Mocks

extension SeriesDetailsModel {
    static func mock(
        id: Int = 1,
        name: String = "Mock Series",
        summary: String? = "<p>Mock summary</p>",
        genres: [String]? = ["Drama"],
        image: ImageData? = .init(medium: nil, original: nil),
        type: String? = "Scripted"
    ) -> SeriesDetailsModel {
        .init(id: id, name: name, summary: summary, genres: genres, image: image, type: type)
    }
}

extension EpisodeModel {
    static func mock(
        id: Int = 1,
        name: String = "Mock Episode",
        season: Int = 1,
        number: Int = 1,
        summary: String? = "<p>Mock episode summary</p>",
        airdate: String? = nil,
        image: EpisodeModel.ImageData? = nil
    ) -> EpisodeModel {
        .init(id: id, name: name, season: season, number: number, summary: summary, airdate: airdate, image: image)
    }
}

extension EpisodeModel.ImageData {
    static var mock: EpisodeModel.ImageData {
        .init(medium: "", original: "")
    }
}

// MARK: - Observer

final class ViewStateSpy<T>: ObservableObject {
    private(set) var values: [ViewState<T>] = []
    private var cancellable: AnyCancellable?

    init(publisher: Published<ViewState<T>>.Publisher) {
        cancellable = publisher
            .sink { [weak self] newValue in
                self?.values.append(newValue)
            }
    }
}
