//
//  FilterCellDatePicker.swift
//  iosapp
//
//  Created by alexander on 08.05.2022.
//

import Foundation
import UIKit
import RangeSeekSlider

class FilterCellDatePicker: UITableViewCell {
    public static let reuseID = "datePickerCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let polsunok: RangeSeekSlider = {
        let view = RangeSeekSlider()
        view.minValue = 0
        view.maxValue = 10
        view.selectedMinValue = 0
        view.selectedMaxValue = 0
        view.enableStep = true
        view.step = 1
        view.minLabelFont = .systemFont(ofSize: 14, weight: .regular)
        view.maxLabelFont = .systemFont(ofSize: 14, weight: .regular)
        view.minLabelColor = .black
        view.maxLabelColor = .black
        view.handleDiameter = 20
        view.lineHeight = 3
        view.tintColor = .gray
        view.labelPadding = -50
        view.colorBetweenHandles = .orange

        view.handleColor = Color.backgroundScreen.color
        view.handleBorderWidth = 0.5
        view.handleBorderColor = .systemGray5
       // view.labelsFixed = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupViews() {
        backgroundColor = .white
        selectionStyle = .none
        heightAnchor.constraint(equalToConstant: CellHeight.filterCellDatePicker.height).isActive = true

        addSubview(label)
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true

        addSubview(polsunok)

        polsunok.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        polsunok.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        polsunok.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        polsunok.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true


    }
}
