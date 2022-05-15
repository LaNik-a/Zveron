//
//  DetailSubCategoryCollectionViewCell.swift
//  iosapp
//
//  Created by alexander on 06.04.2022.
//

import UIKit

class DetailSubCategoryCollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: DetailSubCategoryCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: DetailSubCategoryCollectionViewCell.self), bundle: nil)
    
    @IBOutlet public weak var labelDetailCategory: UILabel!
    
    
    static func getSize(_ text:String, _ sizeOfCollection:CGSize) -> CGSize?{
        //посчитали размер лабел
        // добавить отступы
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1.0
        layer.borderColor = .init(red: 226.0/255.0, green: 130.0/255.0, blue: 19.0/255.0, alpha: 1.0)
        
    }
    
    
    func update(title: String) {
        labelDetailCategory.text = title
    }
}


