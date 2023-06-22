//
//  ArticleCell.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 20/06/23.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageIcon.clipsToBounds = true
        imageIcon.layer.cornerRadius = 30
    }
    

    
    func configureCell(model: ArticleCellModel) {
        if let text = model.titleText, text != "" {
            titleLabel.text = model.titleText
        }else{
            titleLabel.text = "....."
        }
        if let text = model.authorText, text != "" {
            authorLabel.text = model.authorText
        }else{
            authorLabel.text = "....."
        }
        if let text = model.publishedDateText, text != "" {
            publishedDateLabel.text = model.publishedDateText
        }else{
            publishedDateLabel.text = "....."
        }
        if let text = model.categoryText, text != "" {
            categoryLabel.text = model.categoryText
        }else{
            categoryLabel.text = "....."
        }
        if let imageURL = model.imageUrl{
            imageIcon.imageFromServerURL(urlString: imageURL)
        }
    }
}

