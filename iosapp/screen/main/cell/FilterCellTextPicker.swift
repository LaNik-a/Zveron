//
//  FilterCell.swift
//  iosapp
//
//  Created by alexander on 08.05.2022.
//

import Foundation
import UIKit

class FilterCellTextPicker: UITableViewCell {
    public static let reuseID = "textPickerCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let image: UIImageView = {
        let imageView = UIImageView()
        let icon = #imageLiteral(resourceName: "arrow_right_icon")
        imageView.image = icon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private func setupViews() {
        backgroundColor = .white
        selectionStyle = .none
        heightAnchor.constraint(equalToConstant: CellHeight.filterCellTextPicker.height).isActive = true

        addSubview(label)
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        addSubview(image)
        image.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.5).isActive = true
        image.widthAnchor.constraint(equalToConstant: 10).isActive = true
        image.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
    }
}
