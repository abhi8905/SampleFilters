//
//  ViewModel.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 20/06/23.
//

import Foundation
import UIKit
protocol ViewModelDelegate{
    func updateCollection()
    func hideLoader()
    func showLoader()
    func onError(_ error: NetworkManagerError)
}
class ViewModel {
    var currentParams: (Sections,Periods) = (Sections.mostEmailed,Periods.oneDay)
    public var delegate: ViewModelDelegate?
    private var networkManger: NetworkManager
    var landingData: NewsModel? = NewsModel()
    init(networkManger: NetworkManager) {
        self.networkManger = networkManger
    }
    public func loadData(withParams params: (Sections,Periods) = (Sections.mostEmailed,Periods.oneDay)) {
        currentParams = params
        Task {
            await fetchLandingData(withParams: currentParams)
        }
    }
    
    
    private var cellViewModelsForRectangularLayout: [ArticleCellModel] = [ArticleCellModel]()
    private var cellViewModelsForSquareLayout: [ArticleCellModel] = [ArticleCellModel]()

    
    private func fetchLandingData(withParams params: (Sections,Periods)) async {
        self.delegate?.showLoader()
        let result = await networkManger.loadLandingPageData(withParams: params)
        self.delegate?.hideLoader()
        switch result {
        case .failure(let error):
            delegate?.onError(error)
        case .success(let model):
            landingData = model
            self.delegate?.updateCollection()
        }
    }
    
    func getDetailPageData(forIndex index: Int) -> DetailPageModel?{
        guard let results = landingData?.results,results.indices.contains(index) else {
            return nil
        }
        let data = results[index]
        return DetailPageModel(titleText: data.title, imageUrl: data.media?.first?.mediaMetadata?.last?.url, authorText: data.byline, categoryText: data.subsection, descriptionText: data.abstract, publishedDate: data.publishedDate)
    }

    func getArticleCellModels() -> [ArticleCellModel] {
        var articleCellModels = [ArticleCellModel]()
        guard let results = landingData?.results else {
            return []
        }
        for data in results{
            articleCellModels.append(ArticleCellModel(titleText: data.title, imageUrl: data.media?.first?.mediaMetadata?.first?.url, authorText: data.byline, categoryText: data.subsection, publishedDateText: data.publishedDate))
        }
        return articleCellModels
    }
}


