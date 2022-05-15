//
//  ThirdNestingHeader.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class ThirdNestingHeader: BaseHeader {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var topic: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = Color.title.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        collectionView.register(ParameterCell.self, forCellWithReuseIdentifier: ParameterCell.reusableIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private func setup() {
        addSubview(topic)
        addSubview(collectionView)

        topic.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        topic.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true

        collectionView.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 24).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: CellHeight.parameterCell.height).isActive = true
        collectionView.delegate = self
    }

    private var viewModel: ThirdNestingViewModelHeader?
    internal func bindViews(_ viewModel: ThirdNestingViewModelHeader) {
        super.bindViews(viewModel)
        collectionView.rx.itemSelected.bind(onNext: { index in
            viewModel.selectParameterAt(index: index.item)
        }).disposed(by: viewModel.disposeBag)

        viewModel.filter.map { $0.parameters }
        .bind(to: collectionView.rx.items) { _, index, parameter  in
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ParameterCell.reusableIdentifier, for: indexPath) as? ParameterCell else {
                fatalError("")
            }
            cell.data = parameter
            return cell
        }.disposed(by: viewModel.disposeBag)

        viewModel.filter.map { $0.subCategory?.name ?? "" }
        .bind(to: topic.rx.text).disposed(by: viewModel.disposeBag)
        self.viewModel = viewModel
    }
}

extension ThirdNestingHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.4) {
            cell?.alpha = 0.5
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.4) {
            cell?.alpha = 1.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let parameter = viewModel!.filter.value.parameters[indexPath.item]
        let maxWidth = 200.0

        let text: String
        if parameter.choosenValues!.isEmpty {
            text = parameter.name
        } else {
            text = parameter.choosenValues!.joined(separator: ", ")
        }

        let pandingSpace = 50.0
        let needWith = text.width(
            constraintedHeight: collectionView.frame.height,
            font: .systemFont(ofSize: 14, weight: .regular)
        ) + pandingSpace

        let width =  needWith > maxWidth ? maxWidth : needWith
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
