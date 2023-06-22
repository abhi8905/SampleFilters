//
//  ArticleCellModelTests.swift
//  SampleFiltersTests
//
//  Created by Abhinav Jha on 22/06/23.
//

import XCTest

@testable import SampleFilters

class ArticleCellModelTests: XCTestCase {
    
    func testHash() {
        let identifier = UUID()
        let model1 = ArticleCellModel(titleText: "Title 1", imageUrl: "Image 1", authorText: "Author 1", categoryText: "Category 1", publishedDateText: "2023-01-01", identifier: identifier)
        let model2 = ArticleCellModel(titleText: "Title 2", imageUrl: "Image 2", authorText: "Author 2", categoryText: "Category 2", publishedDateText: "2023-02-02", identifier: identifier)
        XCTAssertEqual(model1.hashValue, model2.hashValue)
    }
    
    func testEquality() {
        let identifier = UUID()
        let model1 = ArticleCellModel(titleText: "Title 1", imageUrl: "Image 1", authorText: "Author 1", categoryText: "Category 1", publishedDateText: "2023-01-01", identifier: identifier)
        let model2 = ArticleCellModel(titleText: "Title 2", imageUrl: "Image 2", authorText: "Author 2", categoryText: "Category 2", publishedDateText: "2023-02-02", identifier: identifier)
        
        let model3 = ArticleCellModel(titleText: "Title 3", imageUrl: "Image 3", authorText: "Author 3", categoryText: "Category 3", publishedDateText: "2023-03-03", identifier: UUID())
        XCTAssertTrue(model1 == model2)
        XCTAssertTrue(model2 == model1)
        XCTAssertFalse(model1 == model3)
        XCTAssertFalse(model3 == model1)
    }
    
    func testIdentifierInitialization() {
        let model = ArticleCellModel(titleText: "Title", imageUrl: "Image", authorText: "Author", categoryText: "Category", publishedDateText: "2023-01-01")
        XCTAssertNotNil(model.identifier)
    }
    
}
