//
//  FavoriteTypeCell.swift
//  iosapp
//
//  Created by alexander on 09.05.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RemoteDataService

class FavoriteTypeCell: UICollectionViewCell {
    public static let reuseID = "favoriteHeaderCell"

    var isSelectedCell: Bool? {
        didSet {
            guard isSelected != oldValue else { return }
            updateStyle()
        }
    }

    var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = Color.title.color
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 12
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

   private func updateStyle() {
       removeGradientLayer()
       if isSelectedCell! {
           applyGradient(.mainButton, .horizontal, 12)
           label.textColor = .white
       } else {
           applyGradientForBorder(.mainButton, .horizontal, 1.5, 12)
           label.textColor = Color.title.color
       }
    }
}
