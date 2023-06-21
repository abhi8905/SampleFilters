//
//  ViewController.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 20/06/23.
//

import UIKit
enum Section: CaseIterable {
    case mostViewed
}
class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    var viewModel: ViewModel?
    var networkManager: NetworkManager?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ArticleCellModel>! = nil
    var reuseIdentifier = "ArticleCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Hello"
        networkManager = NetworkManager()
        viewModel = ViewModel(networkManger: networkManager!)
        self.collectionView.registerNib(ArticleCell.self)
        configureCollectionView()
        configureDataSource()
        viewModel?.delegate = self
        viewModel?.loadData()
        // Do any additional setup after loading the view.
    }
    private func presentFilters() {
        guard let filterVC = FilterVC.instance() else {
            return
        }
        filterVC.existingParams = viewModel?.currentParams
        filterVC.delegate = self
        let nav = UINavigationController(rootViewController: filterVC)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        presentFilters()
    }
}

extension ViewController {
    
    private func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.headerMode = .firstItemInSection
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
        collectionView.collectionViewLayout = layout
    }

}
extension ViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ArticleCellModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ArticleCellModel) -> UICollectionViewCell? in
            // Return the cell.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? ArticleCell else {
                fatalError("No cell registered with reuse identifier: \(self.reuseIdentifier)")
            }
            cell.configureCell(model: identifier)
            return cell
        }
    }
    // MARK: Accessor to update datasource

    func reloadCollectionView() {
        guard let viewModel = viewModel else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ArticleCellModel>()
        for section in Section.allCases{
            snapshot.appendSections([section])
            snapshot.appendItems(viewModel.getArticleCellModels(), toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Heekjkhj")
    }
}
extension ViewController:ViewModelDelegate{
    func updateCollection() {
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.reloadCollectionView()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    func showLoader() {
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func onError(_ error: NetworkManagerError) {
        DispatchQueue.main.async {
            self.showAlert("Ups, something went wrong.")
        }
    }
}

extension ViewController: FilterVCDelegate{
    func filterVCDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func filterVCDidChange(params: (Sections, Periods)) {
        viewModel?.loadData(withParams: params)
        dismiss(animated: true, completion: nil)
    }
    
    
}
