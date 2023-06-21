//
//  Extensions.swift
//  SampleFilters
//
//  Created by Abhinav Jha on 20/06/23.
//

import Foundation
import UIKit


extension UICollectionViewCell: Reusable {
    public static var identifierCell: String { return String(describing: self)}
}

public protocol Reusable {
    static var identifierCell: String {get}
}

public extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifierCell, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.identifierCell)
    }
}
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        let urlStringNew = urlString.replacingOccurrences(of: " ", with: "%20")
        URLSession.shared.dataTask(with: NSURL(string: urlStringNew)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            guard let data = data else {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data)
                self.image = image
            })
            
        }).resume()
    }}
extension UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
