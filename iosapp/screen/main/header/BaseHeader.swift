//
//  BaseHeader.swift
//  iosapp
//
//  Created by alexander on 05.05.2022.
//

import Foundation
import UIKit
import DropDown
import RxSwift
import RxCocoa
import Alamofire

class BaseHeader: AdaptiveScrollableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.backgroundScreen.color
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private  lazy var presentationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .orange
        let icon = #imageLiteral(resourceName: "table_icon")
        button.setImage(icon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dropDownContent: DropDown = {
        let dropDownContent = DropDown()
        dropDownContent.dataSource = SortingType.allCases.map { $0.rawValue }
        dropDownContent.cellNib = UINib(nibName: "SortingCell", bundle: nil)
        dropDownContent.cornerRadius = 10
        dropDownContent.separatorColor = .clear
        dropDownContent.backgroundColor = .systemGray6
        dropDownContent.direction = .bottom
        dropDownContent.bottomOffset = CGPoint(x: 0, y: 40)
        dropDownContent.anchorView = sortingButton
        return dropDownContent
    }()

  private lazy var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
      button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitle(SortingType.popularity.rawValue, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(Color.title.color, for: .normal)
        let icon = #imageLiteral(resourceName: "dropdown_icon")
        button.setImage(icon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setupViews() {
        addSubview(presentationButton)
        addSubview(sortingButton)

        presentationButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        presentationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        presentationButton.widthAnchor.constraint(equalTo: presentationButton.heightAnchor).isActive = true
        presentationButton.heightAnchor.constraint(equalTo: sortingButton.heightAnchor).isActive = true

        sortingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        sortingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }

    internal func bindViews(_ viewModel: NestingViewModelBase) {
        dropDownContent.selectionAction = { _, item in
            let type =  SortingType.parseType(item)
            viewModel.sortingType.accept(type)
        }

        sortingButton.rx.tap.bind(onNext: {_ in
            UIView.animate(withDuration: 0.4) { self.sortingButton.alpha = 0.5 }
            UIView.animate(withDuration: 0.4) { self.sortingButton.alpha = 1.0 }

            self.dropDownContent.customCellConfiguration = { _, item, cell in
                let icon = #imageLiteral(resourceName: "check_icon")
                guard let cell = cell as? SortingCell else { return }
                cell.optionLabel.font = .systemFont(ofSize: 16, weight: .regular)
                cell.optionLabel.textColor = Color.title.color
                let isSelected = item == viewModel.sortingType.value.rawValue
                cell.logoImage.image = isSelected ? icon : nil
            }
            self.dropDownContent.show()
        }).disposed(by: viewModel.disposeBag)

        viewModel.sortingType.bind(onNext: { value in
            self.sortingButton.setTitle(value.rawValue, for: .normal)
            self.sortingButton.layoutButton(style: .Right, imageTitleSpace: 5)
        }).disposed(by: viewModel.disposeBag)

        presentationButton.rx.tap.bind(onNext: {
            var newValue = viewModel.presentationModeType.value
            newValue.toggle()
            viewModel.presentationModeType.accept(newValue)
        }).disposed(by: viewModel.disposeBag)

        viewModel.presentationModeType.bind(onNext: {
            self.presentationButton.setImage($0.buttonImage, for: .normal)
        }).disposed(by: viewModel.disposeBag)

        viewModel.currentOffset.bind(to: self.rx.currentOffset).disposed(by: viewModel.disposeBag)
    }
}
