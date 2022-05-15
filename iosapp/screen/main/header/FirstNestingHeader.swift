//
//  NewHeader.swift
//  iosapp
//
//  Created by alexander on 04.05.2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class FirstNestingHeader: BaseHeader {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

private var topic: UILabel = {
    let label = UILabel()
    label.text = "Категории"
    label.font = .systemFont(ofSize: 28, weight: .medium)
    label.textColor = Color.title.color
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

private var animalButton: UIButton = {
    let button = UIButton(type: .custom)
    let icon = #imageLiteral(resourceName: "animals_image")
    let backgroundIcon = #imageLiteral(resourceName: "animals_background")
    button.setTitle("Животные", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
    button.setTitleColor(.black, for: .normal)
    button.setImage(icon, for: .normal)
    button.setBackgroundImage(backgroundIcon, for: .normal)
    button.contentVerticalAlignment = .center
    button.contentHorizontalAlignment = .center
    button.contentMode = .scaleToFill
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

private var goodsButton: UIButton = {
    let button = UIButton(type: .custom)
    let icon = #imageLiteral(resourceName: "product_image")
    let backgroundIcon = #imageLiteral(resourceName: "product_background")
    button.setTitle("Товары", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
    button.setTitleColor(.black, for: .normal)
    button.setImage(icon, for: .normal)
    button.setBackgroundImage(backgroundIcon, for: .normal)
    button.contentVerticalAlignment = .center
    button.contentHorizontalAlignment = .center
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

private func setUp() {
    addSubview(topic)
    addSubview(animalButton)
    addSubview(goodsButton)
    topic.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    topic.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true

    let widthForButtons = (frame.width - 32 - 32) / 2
    animalButton.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 24).isActive = true
    animalButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    animalButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
    animalButton.widthAnchor.constraint(equalToConstant: widthForButtons).isActive = true
    goodsButton.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 24).isActive = true
    goodsButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    goodsButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
    goodsButton.widthAnchor.constraint(equalToConstant: widthForButtons).isActive = true
    animalButton.layoutButton(style: .Top, imageTitleSpace: 10.0)
    goodsButton.layoutButton(style: .Top, imageTitleSpace: 10.0)
}

    internal func bindViews(_ viewModel: FirstNestingViewModelHeader) {
      super.bindViews(viewModel)

        animalButton.rx.tap.bind(onNext: {
            viewModel.selectedCategory.accept(Category(id: 1, name: "Животные"))
        }).disposed(by: viewModel.disposeBag)

        goodsButton.rx.tap.bind(onNext: {
            viewModel.selectedCategory.accept(Category(id: 2, name: "Товары"))
        }).disposed(by: viewModel.disposeBag)
    }
}
