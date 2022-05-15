//
//  ParameterCell.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation

import Foundation
import UIKit

class ParameterCell: UICollectionViewCell {
    public static let reusableIdentifier = "parameterCell"

    var data: LotParameter? {
        didSet {
            guard let parameter = data else { return }
            self.removeGradientLayer()

            if parameter.choosenValues!.isEmpty {
                self.applyGradientForBorder(.mainButton, .horizontal, 1.5, 20.0)
                label.text = parameter.name
                label.textColor = .black
                imageView.image = imageView.image?.withTintColor(.black)
            } else {
                self.applyGradient(.mainButton, .horizontal, 20.0)
                label.textColor = .white
                label.text = parameter.choosenValues!.joined(separator: ", ")
                imageView.image = imageView.image?.withTintColor(.white)
            }
        }
    }

    override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let icon = #imageLiteral(resourceName: "dropdown_icon")
        imageView.image = icon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 20.0
        addSubview(label)
        addSubview(imageView)
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
    }
}
