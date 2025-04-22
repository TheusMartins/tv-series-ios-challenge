//
//  RequesterTests.swift
//  Network
//
//  Created by Matheus Martins on 22/04/25.
//


import XCTest
@testable import Networking

final class RequesterTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }

    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_request_invalidURL_shouldThrowInvalidURL() async throws {
        let sut = DefaultRequester()
        let infos = InvalidRequest()

        do {
            _ = try await sut.request(basedOn: infos)
            XCTFail("Should not succeed with invalid URL")
        } catch {
            XCTAssertEqual(error as? RequestError, .invalidURL)
        }
    }

    func test_request_validURL_withError_shouldThrowInvalidResponse() async throws {
        let sut = DefaultRequester()
        let infos = ValidRequest()
        URLProtocolStub.stub(data: nil, response: nil, error: RequestError.invalidResponse)

        do {
            _ = try await sut.request(basedOn: infos)
            XCTFail("Should not succeed with stubbed error")
        } catch {
            XCTAssertEqual(error as? RequestError, .invalidResponse)
        }
    }

    func test_request_validURL_withResponse_shouldReturnSuccess() async throws {
        let expectedData = Data("response".utf8)
        let expectedResponse = URLResponse(url: URL(string: "https://api.tvmaze.com")!,
                                           mimeType: nil,
                                           expectedContentLength: expectedData.count,
                                           textEncodingName: nil)

        URLProtocolStub.stub(data: expectedData, response: expectedResponse, error: nil)

        let sut = DefaultRequester()
        let infos = ValidRequest()

        let result = try await sut.request(basedOn: infos)

        XCTAssertEqual(result.data, expectedData)
        XCTAssertEqual(result.response.url?.absoluteString, "https://api.tvmaze.com")
    }

    // MARK: - Helpers

    private struct InvalidRequest: RequestInfos {
        var endpoint: String = "invalid"
        var method: HTTPMethod = .get
        var parameters: [String: Any]? = nil
        var baseURL: URL? = nil
    }

    private struct ValidRequest: RequestInfos {
        var endpoint: String = "valid"
        var method: HTTPMethod = .get
        var parameters: [String: Any]? = nil
    }
}
