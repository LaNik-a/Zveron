//
//  SubCategoryCollectionViewCell.swift
//  iosapp
//
//  Created by alexander on 29.03.2022.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {
    public static let reusableIdentifier = "subcategoryCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var data: Category? {
        didSet {
            guard let data = data else { return }
            labelCell.text = data.name
            let icon =  UIImage.init(named: "subcategory_icon_\(data.id)")
            imageCell.image  = icon ?? #imageLiteral(resourceName: "error_icon")
            print(data)
        }
    }

   private let labelCell: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private func setupViews() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(labelCell)
        addSubview(imageCell)

        imageCell.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageCell.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageCell.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageCell.heightAnchor.constraint(equalTo: imageCell.widthAnchor).isActive = true

        labelCell.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelCell.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelCell.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
