//
//  DetailViewController.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 21/06/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var detailPageData: DetailPageModel?
    class func instance() -> DetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return nil
        }
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = detailPageData else{
            return
        }
        publishedDateLabel.text = data.publishedDateText
        if let imageURL = data.imageUrl{
            articleImage.imageFromServerURL(urlString: imageURL)
        }
        if let text = data.titleText, text != "" {
            titleLabel.text = data.titleText
        }else{
            titleLabel.text = "....."
        }
        if let text = data.authorText, text != "" {
            authorLabel.text = data.authorText
        }else{
            authorLabel.text = "....."
        }
        if let text = data.descriptionText, text != "" {
            descriptionLabel.text = data.descriptionText
        }else{
            descriptionLabel.text = "....."
        }
        if let text = data.categoryText, text != "" {
            categoryLabel.text = data.categoryText
        }else{
            categoryLabel.text = "....."
        }
        // Do any additional setup after loading the view.
    }
    
    func setUpDetailVC(withData data: DetailPageModel){
        detailPageData = data
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
