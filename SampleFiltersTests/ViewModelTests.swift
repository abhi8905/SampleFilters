//
//  ViewModelTests.swift
//  SampleFiltersTests
//
//  Created by Abhinav Jha on 21/06/23.
//

import XCTest

@testable import SampleFilters
class MockDelegate: ViewModelDelegate {
    var updateCollectionCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    var onErrorCalled = false
    var error: NetworkManagerError?
    var updateCollectionExpectation: XCTestExpectation?
    var showLoaderExpectation: XCTestExpectation?
    var hideLoaderExpectation: XCTestExpectation?
    
    func updateCollection() {
        updateCollectionCalled = true
        updateCollectionExpectation?.fulfill()
    }
    
    func showLoader() {
        showLoaderCalled = true
        showLoaderExpectation?.fulfill()
    }
    
    func hideLoader() {
        hideLoaderCalled = true
        hideLoaderExpectation?.fulfill()
    }
    
    func onError(_ error: NetworkManagerError) {
        onErrorCalled = true
        self.error = error
    }
}




class MockNetworkManager: NetworkManager {
    var loadLandingPageDataCalled = false
    var expectedResult: Swift.Result<NewsModel, NetworkManagerError>?
    
    override func loadLandingPageData(withParams params: (Sections, Periods)) async -> Swift.Result<NewsModel, NetworkManagerError> {
        loadLandingPageDataCalled = true
        if let result = expectedResult {
            return result
        } else {
            return .failure(.unknown)
        }
    }
}

class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    var delegate: MockDelegate!
    var networkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        delegate = MockDelegate()
        networkManager = MockNetworkManager()
        viewModel = ViewModel(networkManger: networkManager)
        viewModel.delegate = delegate
    }
    
    override func tearDown() {
        viewModel = nil
        delegate = nil
        networkManager = nil
        super.tearDown()
    }
    
    func testLoadData_Success() {
        let newsModel = NewsModel()
        networkManager.expectedResult = .success(newsModel)
        viewModel.delegate = delegate
        let showLoaderExpectation = XCTestExpectation(description: "showLoader expectation")
        let hideLoaderExpectation = XCTestExpectation(description: "hideLoader expectation")
        delegate.showLoaderExpectation = showLoaderExpectation
        delegate.hideLoaderExpectation = hideLoaderExpectation
        viewModel.loadData()
        wait(for: [showLoaderExpectation, hideLoaderExpectation], timeout: 5.0)
        XCTAssertTrue(delegate.showLoaderCalled)
        XCTAssertTrue(delegate.hideLoaderCalled)
        XCTAssertTrue(delegate.updateCollectionCalled)
        XCTAssertFalse(delegate.onErrorCalled)
        XCTAssertEqual(viewModel.landingData, newsModel)
    }



    
    func testLoadData_Failure() {
        let error = NetworkManagerError.unknown
        networkManager.expectedResult = .failure(error)
        viewModel.delegate = delegate
        let showLoaderExpectation = XCTestExpectation(description: "showLoader expectation")
        let hideLoaderExpectation = XCTestExpectation(description: "hideLoader expectation")
        delegate.showLoaderExpectation = showLoaderExpectation
        delegate.hideLoaderExpectation = hideLoaderExpectation
        viewModel.loadData()
        wait(for: [showLoaderExpectation, hideLoaderExpectation], timeout: 5.0)
        XCTAssertTrue(delegate.showLoaderCalled)
        XCTAssertTrue(delegate.hideLoaderCalled)
        XCTAssertFalse(delegate.updateCollectionCalled)
        XCTAssertTrue(delegate.onErrorCalled)
        XCTAssertEqual(delegate.error, error)
    }
    
    func testGetDetailPageData_ValidIndex() {
        let title = "Test Title"
        let imageUrl = "https://example.com/image.jpg"
        let author = "Test Author"
        let category = "Test Category"
        let description = "Test Description"
        let publishedDate = "2023-06-06"
        
        let data = Result(publishedDate: publishedDate, subsection: category, byline: author, title: title, abstract: description, media: [Media(mediaMetadata: [MediaMetadatum(url: imageUrl)])])
        viewModel.landingData?.results = [data]
        
        let detailPageModel = viewModel.getDetailPageData(forIndex: 0)
        
        XCTAssertNotNil(detailPageModel)
        XCTAssertEqual(detailPageModel?.titleText, title)
        XCTAssertEqual(detailPageModel?.imageUrl, imageUrl)
        XCTAssertEqual(detailPageModel?.authorText, author)
        XCTAssertEqual(detailPageModel?.categoryText, category)
        XCTAssertEqual(detailPageModel?.descriptionText, description)
        XCTAssertEqual(detailPageModel?.publishedDate, publishedDate)
    }
    
    func testGetDetailPageData_InvalidIndex() {
        let detailPageModel = viewModel.getDetailPageData(forIndex: 0)
        
        XCTAssertNil(detailPageModel)
    }
    func testGetArticleCellModels() {
        let title1 = "Test Title 1"
        let imageUrl1 = "https://example.com/image1.jpg"
        let author1 = "Test Author 1"
        let category1 = "Test Category 1"
        let publishedDate1 = "2023-06-06"
        
        let title2 = "Test Title 2"
        let imageUrl2 = "https://example.com/image2.jpg"
        let author2 = "Test Author 2"
        let category2 = "Test Category 2"
        let publishedDate2 = "2023-06-07"
        
        let data1 = Result(publishedDate: publishedDate1, subsection: category1, byline: author1, title: title1, abstract: nil, media: [Media(mediaMetadata: [MediaMetadatum(url: imageUrl1)])])
        
        let data2 = Result(publishedDate: publishedDate2, subsection: category2, byline: author2, title: title2, abstract: nil, media: [Media(mediaMetadata: [MediaMetadatum(url: imageUrl2)])])
        
        viewModel.landingData?.results = [data1, data2]
        
        let articleCellModels = viewModel.getArticleCellModels()
        
        XCTAssertEqual(articleCellModels.count, 2)
        
        XCTAssertEqual(articleCellModels[0].titleText, title1)
        XCTAssertEqual(articleCellModels[0].imageUrl, imageUrl1)
        XCTAssertEqual(articleCellModels[0].authorText, author1)
        XCTAssertEqual(articleCellModels[0].categoryText, category1)
        XCTAssertEqual(articleCellModels[0].publishedDateText, publishedDate1)
        
        XCTAssertEqual(articleCellModels[1].titleText, title2)
        XCTAssertEqual(articleCellModels[1].imageUrl, imageUrl2)
        XCTAssertEqual(articleCellModels[1].authorText, author2)
        XCTAssertEqual(articleCellModels[1].categoryText, category2)
        XCTAssertEqual(articleCellModels[1].publishedDateText, publishedDate2)
    }
    func testGetArticleCellModels_WhenNoResults() {
        viewModel.landingData = NewsModel()
        let articleCellModels = viewModel.getArticleCellModels()
        XCTAssertTrue(articleCellModels.isEmpty)
    }
}

    
   
