//
//  ArticleCellModel.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 20/06/23.
//

import Foundation
struct ArticleCellModel: Hashable {
    let titleText: String?
    let imageUrl: String?
    let authorText: String?
    let categoryText: String?
    let publishedDateText: String?
    var identifier = UUID()

    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: ArticleCellModel, rhs: ArticleCellModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
