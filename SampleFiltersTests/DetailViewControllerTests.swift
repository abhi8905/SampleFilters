//
//  DetailViewControllerTests.swift
//  SampleFiltersTests
//
//  Created by Abhinav Jha on 22/06/23.
//

import XCTest

@testable import SampleFilters

class DetailViewControllerTests: XCTestCase {
    
    var viewController: DetailViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            XCTFail("Failed to instantiate DetailViewController")
            return
        }
        viewController = vc
        _ = viewController.view
    }


    
    func testInstance_ValidIdentifier() {
        let viewController = DetailViewController.instance()
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is DetailViewController)
    }



    func testViewDidLoad_NoDetailPageData() {
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.publishedDateLabel.text, "Label")
        XCTAssertEqual(viewController.titleLabel.text, "Label")
        XCTAssertEqual(viewController.authorLabel.text, "Label")
        XCTAssertEqual(viewController.categoryLabel.text, "Label")
        XCTAssertEqual(viewController.descriptionLabel.text, "Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label Label")
    }


    func testViewDidLoad_WithDetailPageData() {
        let detailPageData = DetailPageModel(titleText: "Title", imageUrl: "ImageURL", authorText: "Author", categoryText: "Category", descriptionText: "Description", publishedDate: "2023-06-06")
        viewController.detailPageData = detailPageData
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.publishedDateLabel.text, "Published : 2023-06-06")
        XCTAssertEqual(viewController.titleLabel.text, "Title")
        XCTAssertEqual(viewController.authorLabel.text, "Author")
        XCTAssertEqual(viewController.categoryLabel.text, "Category")
        XCTAssertEqual(viewController.descriptionLabel.text, "Description")
    }
    
    func testSetUpDetailVC() {
        let detailPageData = DetailPageModel(titleText: "Title", imageUrl: "ImageURL", authorText: "Author", categoryText: "Category", descriptionText: "Description", publishedDate: "2023-06-06")
        viewController.setUpDetailVC(withData: detailPageData)
        XCTAssertEqual(viewController.detailPageData?.titleText, "Title")
        XCTAssertEqual(viewController.detailPageData?.imageUrl, "ImageURL")
        XCTAssertEqual(viewController.detailPageData?.authorText, "Author")
        XCTAssertEqual(viewController.detailPageData?.categoryText, "Category")
        XCTAssertEqual(viewController.detailPageData?.descriptionText, "Description")
        XCTAssertEqual(viewController.detailPageData?.publishedDate, "2023-06-06")
    }
}
