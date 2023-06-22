//
//  ArticleCellTests.swift
//  SampleFiltersTests
//
//  Created by Abhinav Jha on 22/06/23.
//

import XCTest
@testable import SampleFilters

class ArticleCellTests: XCTestCase {
    
    var cell: ArticleCell!
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: ArticleCell.self)
        let nib = UINib(nibName: "ArticleCell", bundle: bundle)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        if let cell = objects.first as? ArticleCell {
            self.cell = cell
        } else {
            XCTFail("Failed to instantiate ArticleCell")
        }
    }
    
    func testAwakeFromNib() {
        cell.awakeFromNib()
        XCTAssertTrue(cell.imageIcon.clipsToBounds)
        XCTAssertEqual(cell.imageIcon.layer.cornerRadius, 30)
    }
    
    func testConfigureCell() {
        let model = ArticleCellModel(titleText: "Title", imageUrl: "ImageURL", authorText: "Author", categoryText: "Category", publishedDateText: "Published Date")
        cell.configureCell(model: model)
        XCTAssertEqual(cell.titleLabel.text, "Title")
        XCTAssertEqual(cell.authorLabel.text, "Author")
        XCTAssertEqual(cell.publishedDateLabel.text, "Published Date")
        XCTAssertEqual(cell.categoryLabel.text, "Category")
    }
    
    func testConfigureCellWithoutTitle() {
        let model = ArticleCellModel(titleText: nil, imageUrl: nil, authorText: nil, categoryText: nil, publishedDateText: nil)
        cell.configureCell(model: model)
        XCTAssertEqual(cell.titleLabel.text, ".....")
        XCTAssertEqual(cell.authorLabel.text, ".....")
        XCTAssertEqual(cell.publishedDateLabel.text, ".....")
        XCTAssertEqual(cell.categoryLabel.text, ".....")
    }
}

