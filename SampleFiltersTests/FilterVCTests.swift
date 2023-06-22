//
//  FilterVCTests.swift
//  SampleFiltersTests
//
//  Created by Abhinav Jha on 22/06/23.
//

import XCTest

@testable import SampleFilters

class FilterVCTests: XCTestCase {

    var filterVC: FilterVC!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        filterVC = storyboard.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        filterVC.loadViewIfNeeded()
    }

    override func tearDown() {
        filterVC = nil
        super.tearDown()
    }
    
    func testInstance_ValidIdentifier() {
        let viewController = FilterVC.instance()
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is FilterVC)
    }

    func testSectionsFilterTapped() {
        let mostViewedBtn = UIButton()
        mostViewedBtn.tag = 3
        let mostSharedBtn = UIButton()
        mostSharedBtn.tag = 2
        let mostEmailedBtn = UIButton()
        mostEmailedBtn.tag = 1
        filterVC.sectionsFilterTapped(mostEmailedBtn)
        XCTAssertEqual(filterVC.sectionFilter, .mostEmailed)
        filterVC.sectionsFilterTapped(mostSharedBtn)
        XCTAssertEqual(filterVC.sectionFilter, .mostShared)
        filterVC.sectionsFilterTapped(mostViewedBtn)
        XCTAssertEqual(filterVC.sectionFilter, .mostViewed)
    }
    
    func testParamsDidChange() {
        // Test when existingParams is nil
        filterVC.existingParams = nil
        filterVC.sectionFilter = .mostEmailed
        filterVC.periodFilter = .oneDay
        XCTAssertTrue(filterVC.paramsDidChange)
        
        // Test when existingParams is not nil and matches the current filters
        filterVC.existingParams = (.mostEmailed, .oneDay)
        XCTAssertFalse(filterVC.paramsDidChange)
        
        // Test when existingParams is not nil and doesn't match the current filters
        filterVC.existingParams = (.mostShared, .oneMonth)
        XCTAssertTrue(filterVC.paramsDidChange)
        
        // Test when existingParams is not nil and matches the current filters for one attribute only
        filterVC.existingParams = (.mostEmailed, .oneWeek)
        XCTAssertTrue(filterVC.paramsDidChange)
    }


    func testPeriodsFilterTapped() {
        let oneDayBtn = UIButton()
        oneDayBtn.tag = 1
        let oneWeekBtn = UIButton()
        oneWeekBtn.tag = 2
        let oneMonthBtn = UIButton()
        oneMonthBtn.tag = 3
        filterVC.periodsFilterTapped(oneDayBtn)
        XCTAssertEqual(filterVC.periodFilter, .oneDay)
        filterVC.periodsFilterTapped(oneWeekBtn)
        XCTAssertEqual(filterVC.periodFilter, .oneWeek)
        filterVC.periodsFilterTapped(oneMonthBtn)
        XCTAssertEqual(filterVC.periodFilter, .oneMonth)
    }


    func testApplyBtnTapped() {
        let delegate = FilterVCDelegateMock()
        filterVC.delegate = delegate
        filterVC.sectionFilter = .mostShared
        filterVC.periodFilter = .oneWeek
        filterVC.applyBtnTapped(self)
        
        XCTAssertTrue(delegate.didCallFilterVCDidChange)
        
        if let params = delegate.params {
            XCTAssertEqual(params.0, .mostShared)
            XCTAssertEqual(params.1, .oneWeek)
        } else {
            XCTFail("Delegate params should not be nil")
        }
    }
    
    func testSectionsFilterExpand() {
        let sectionsStackView = UIStackView()
        let sectionsFilterExpandBtn = UIButton()
        filterVC.sectionsStackView = sectionsStackView
        filterVC.sectionsFilterExpand(sectionsFilterExpandBtn)
        XCTAssertTrue(filterVC.isSectionExpanded)
        XCTAssertFalse(sectionsStackView.isHidden)
        filterVC.sectionsFilterExpand(sectionsFilterExpandBtn)
        XCTAssertFalse(filterVC.isSectionExpanded)
        XCTAssertTrue(sectionsStackView.isHidden)
    }

//    func testCloseFilterTapped() {
//        let delegate = FilterVCDelegateMock()
//        filterVC.delegate = delegate
//        filterVC.paramsDidChange = true
//        filterVC.closeFilterTapped(self)
//        XCTAssertTrue(delegate.didCallFilterVCDidCancel)
//        filterVC.paramsDidChange = false
//        filterVC.closeFilterTapped(self)
//        XCTAssertFalse(delegate.didCallFilterVCDidCancel)
//    }

    // Mock implementation of FilterVCDelegate for testing
    class FilterVCDelegateMock: FilterVCDelegate {
        var didCallFilterVCDidChange = false
        var didCallFilterVCDidCancel = false
        var params: (Sections, Periods)?

        func filterVCDidChange(params: (Sections, Periods)) {
            didCallFilterVCDidChange = true
            self.params = params
        }

        func filterVCDidCancel() {
            didCallFilterVCDidCancel = true
        }
    }
}
