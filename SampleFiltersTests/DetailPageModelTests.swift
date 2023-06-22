//
//  DetailPageModelTests.swift
//  SampleFiltersTests
//
//  Created by Abhinav Jha on 22/06/23.
//

import XCTest

@testable import SampleFilters

class DetailPageModelTests: XCTestCase {
    
    func testPublishedDateText_NilPublishedDate() {
        let model = DetailPageModel(titleText: "Title", imageUrl: "Image", authorText: "Author", categoryText: "Category", descriptionText: "Description", publishedDate: nil)
        let publishedDateText = model.publishedDateText
        XCTAssertEqual(publishedDateText, "")
    }
    
    func testPublishedDateText_NonNilPublishedDate() {
        let model = DetailPageModel(titleText: "Title", imageUrl: "Image", authorText: "Author", categoryText: "Category", descriptionText: "Description", publishedDate: "2023-01-01")
        let publishedDateText = model.publishedDateText
        XCTAssertEqual(publishedDateText, "Published : 2023-01-01")
    }
}
