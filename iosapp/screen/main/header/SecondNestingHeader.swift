//
//  SecondNestingLevelHeader.swift
//  iosapp
//
//  Created by alexander on 05.05.2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SecondNestingHeader: BaseHeader {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
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

    private var showAll: UIButton = {
        let button = UIButton(type: .system)
        let color = #colorLiteral(red: 0.8209876418, green: 0.821508944, blue: 0.8374733329, alpha: 1)
        button.setTitle("смотреть все", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(color, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        collectionView.register(SubCategoryCell.self, forCellWithReuseIdentifier: SubCategoryCell.reusableIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()


    private func setUp() {
        addSubview(topic)
        addSubview(showAll)
        addSubview(collectionView)

        topic.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        topic.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true

        showAll.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        showAll.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        showAll.centerYAnchor.constraint(equalTo: topic.centerYAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 24).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: CellHeight.subCategoryCell.height).isActive = true
        collectionView.delegate = self
    }

    internal func bindViews(_ viewModel: SecondNestingViewModelHeader) {
      super.bindViews(viewModel)
        collectionView.rx.itemSelected.bind(onNext: { index in
            viewModel.selectSubCategoryAt(index: index.item)
        }).disposed(by: viewModel.disposeBag)

        viewModel.subCategories.bind(to: collectionView.rx.items) { _,index, subCategory  in
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCell.reusableIdentifier, for: indexPath) as? SubCategoryCell else {
                fatalError("")
            }
            cell.data = subCategory
            return cell
        }.disposed(by: viewModel.disposeBag)

        showAll.rx.tap.bind(onNext: {_ in
            viewModel.needShowAllSubCategories.accept(nil)
        }).disposed(by: viewModel.disposeBag)

        viewModel.filter.map { $0.category?.name ?? "" }.bind(to: topic.rx.text).disposed(by: viewModel.disposeBag)
    }
}

extension SecondNestingHeader: UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: 80, height: collectionView.frame.height)
    }
}
