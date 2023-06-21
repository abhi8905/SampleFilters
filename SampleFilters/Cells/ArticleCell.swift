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
        
        imageIcon.clipsToBounds = true;
        imageIcon.layer.cornerRadius = 30;
    }
    

    
    func configureCell(model: ArticleCellModel) {
        titleLabel.text = model.titleText
        authorLabel.text =   model.authorText
        publishedDateLabel.text = model.publishedDateText
        categoryLabel.text = model.categoryText
        if let imageURL = model.imageUrl{
            imageIcon.imageFromServerURL(urlString: imageURL)
        }
    }
}

