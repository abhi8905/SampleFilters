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
    
    public var delegate: ViewModelDelegate?
    private var networkManger: NetworkManager
    var landingData: NewsModel? = NewsModel()
    init(networkManger: NetworkManager) {
        self.networkManger = networkManger
    }
    public func loadData() {
        Task {
            await fetchLandingData()
        }
    }
    
    
    private var cellViewModelsForRectangularLayout: [ArticleCellModel] = [ArticleCellModel]()
    private var cellViewModelsForSquareLayout: [ArticleCellModel] = [ArticleCellModel]()

    
    private func fetchLandingData() async {
        self.delegate?.showLoader()
        let result = await networkManger.loadLandingPageData()
        self.delegate?.hideLoader()
        switch result {
        case .failure(let error):
            delegate?.onError(error)
        case .success(let model):
            landingData = model
            self.delegate?.updateCollection()
        }
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


