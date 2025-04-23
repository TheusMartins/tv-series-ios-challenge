//
//  SeriesListViewModelTests.swift
//  TVSeriesAppTests
//
//  Created by Matheus Martins on 24/04/25.
//

import XCTest
@testable import TVSeriesApp

final class SeriesListViewModelTests: XCTestCase {

    // MARK: - Helpers

    @MainActor private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SeriesListViewModel, spy: SeriesListRepositorySpy) {
        let spy = SeriesListRepositorySpy()
        let sut = SeriesListViewModel(repository: spy)
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

    func test_fetchInitialSeries_success_shouldSetStateToSuccess() async {
        // Given
        let (sut, spy) = await makeSUT()
        spy.result = .success([.mock(id: 1), .mock(id: 2)])

        // When
        await sut.fetchInitialSeries()

        // Then
        switch await sut.state {
        case .success(let items):
            XCTAssertEqual(items.count, 2)
        default:
            XCTFail("Expected success state")
        }
    }

    func test_fetchInitialSeries_failure_shouldSetStateToError() async {
        // Given
        let (sut, spy) = await makeSUT()
        spy.result = .failure(NSError(domain: "Test", code: 0))

        // When
        await sut.fetchInitialSeries()

        // Then
        switch await sut.state {
        case .error:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected error state")
        }
    }

    func test_fetchNextPageIfNeeded_shouldAppendItemsWhenNearBottom() async {
        // Given
        let (sut, spy) = await makeSUT()
        let initialItems = (1...10).map { SeriesListModel.mock(id: $0) }
        spy.result = .success(initialItems)
        await sut.fetchInitialSeries()

        // When
        spy.result = .success([.mock(id: 11)])
        await sut.fetchNextPageIfNeeded(currentItem: initialItems[5])

        // Then
        switch await sut.state {
        case .success(let items):
            XCTAssertEqual(items.count, 11)
        default:
            XCTFail("Expected success with appended items")
        }
    }

    func test_fetchNextPageIfNeeded_shouldNotAppendWhenNoMorePages() async {
        // Given
        let (sut, spy) = await makeSUT()
        let initialItems = (1...10).map { SeriesListModel.mock(id: $0) }
        spy.result = .success(initialItems)
        await sut.fetchInitialSeries()

        // When
        spy.result = .success([]) 
        await sut.fetchNextPageIfNeeded(currentItem: initialItems[9])

        // Then
        switch await sut.state {
        case .success(let items):
            XCTAssertEqual(items.count, 10)
        default:
            XCTFail("Expected success with same items")
        }
    }
    
    func test_searchSeries_shouldSetStateToSuccess() async {
        // Given
        let (sut, spy) = await makeSUT()
        await MainActor.run { sut.searchText = "Friends" }
        spy.searchResult = .success([.mock(id: 1, name: "Friends")])

        // When
        await sut.searchSeries()

        // Then
        switch await sut.state {
        case .success(let results):
            XCTAssertEqual(results.first?.name, "Friends")
        default:
            XCTFail("Expected success state with results")
        }
    }

    func test_searchSeries_shouldSetStateToErrorOnFailure() async {
        // Given
        let (sut, spy) = await makeSUT()
        await MainActor.run { sut.searchText = "Lost" }
        spy.searchResult = .failure(NSError(domain: "TestError", code: 0))

        // When
        await sut.searchSeries()

        // Then
        switch await sut.state {
        case .error(let message):
            XCTAssertEqual(message, "Failed to search series.")
        default:
            XCTFail("Expected error state")
        }
    }

    func test_searchSeries_shouldFallbackToInitialFetchWhenTextIsEmpty() async {
        // Given
        let (sut, spy) = await makeSUT()
        await MainActor.run { sut.searchText = "" }
        spy.result = .success([.mock(id: 42)])
        
        // When
        await sut.searchSeries()

        // Then
        switch await sut.state {
        case .success(let results):
            XCTAssertEqual(results.first?.id, 42)
        default:
            XCTFail("Expected fallback to initial fetch")
        }
    }
}

// MARK: - Spy

final class SeriesListRepositorySpy: SeriesListRepository {
    var result: Result<[SeriesListModel], Error> = .success([])
    private(set) var receivedPages: [Int] = []

    func getSeriesList(page: Int) async throws -> [SeriesListModel] {
        receivedPages.append(page)
        return try result.get()
    }
    
    var searchResult: Result<[SeriesListModel], Error> = .success([])

    func searchSeries(by query: String) async throws -> [SeriesListModel] {
        return try searchResult.get()
    }
}

// MARK: - Mock

extension SeriesListModel {
    static func mock(id: Int = 0, name: String = "Mock Title") -> SeriesListModel {
        SeriesListModel(
            id: id,
            name: name,
            image: nil, summary: nil
        )
    }
}

extension SeriesListModel: @retroactive Equatable {
    public static func == (lhs: SeriesListModel, rhs: SeriesListModel) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
