//
//  DetailPageModel.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 21/06/23.
//

import Foundation


struct DetailPageModel {
    let titleText: String?
    let imageUrl: String?
    let authorText: String?
    let categoryText: String?
    let descriptionText: String?
    let publishedDate: String?
    var publishedDateText: String {
        guard let publishedDate = publishedDate else {
            return ""
        }
        return "Published : \(publishedDate)"
    }

}
