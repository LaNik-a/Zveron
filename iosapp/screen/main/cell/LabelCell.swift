//
//  LabelCell.swift
//  iosapp
//
//  Created by alexander on 02.05.2022.
//

import Foundation
import UIKit

class LabelCell: UICollectionViewCell {
    public static let reusableIdentifier = "labelCell"

    override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       private func setupViews() {
            backgroundColor = Color.backgroundScreen.color
            addSubview(label)
            label.topAnchor.constraint(equalTo: topAnchor).isActive = true
            label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

    func isSelect(_ value: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.label.alpha = value ? 1.0 : 0.5
        }
    }
}

