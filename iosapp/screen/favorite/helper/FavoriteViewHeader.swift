//
//  FavoriteViewHeader.swift
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

class FavoriteViewHeader: UIView {
    var delegate: FavoriteHeaderDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var topic: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = Color.title.color
        label.text = "Избранное"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var settingButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = #imageLiteral(resourceName: "settings_icon_2").withTintColor(.black)
        button.setImage(icon, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Поиск"
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .clear)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .bookmark)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FavoriteTypeCell.self, forCellWithReuseIdentifier: FavoriteTypeCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private func setupViews() {
        addSubview(topic)
        addSubview(settingButton)
        addSubview(searchBar)
        addSubview(collectionView)

        topic.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topic.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        settingButton.centerYAnchor.constraint(equalTo: topic.centerYAnchor).isActive = true
        settingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true

        searchBar.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 12).isActive = true
        searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: -12).isActive = true
        searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: CellHeight.favoriteTypeCell.height).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.delegate = self
    }
    private var viewModel: FavoriteViewModel?

    func bindViews(_ viewModel: FavoriteViewModel) {
//        viewModel.dataSourceTypes.bind(to: collectionView.rx.items) { collectionView, index, category in
//            let indexPath = IndexPath(item: index, section: 0)
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteTypeCell.reuseID, for: indexPath) as? FavoriteTypeCell else {
//                fatalError("")
//            }
//
//            cell.label.text = category.name
//            cell.isSelectedCell = viewModel.selectedDataSoruceType.value.id == category.id
//            return cell
//        }.disposed(by: viewModel.disposeBag)
//
//        viewModel.selectedDataSoruceType.bind { category in
//            for i in 0..<viewModel.dataSourceTypes.value.count {
//                (self.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? FavoriteTypeCell)?.isSelectedCell = false
//            }
//            let idx = viewModel.dataSourceTypes.value.firstIndex { $0.name == category.name }!
//            let indexPath = IndexPath(item: idx, section: 0)
//            (self.collectionView.cellForItem(at: indexPath) as? FavoriteTypeCell)?.isSelectedCell = true
//        }.disposed(by: viewModel.disposeBag)
//
//        collectionView.rx.itemSelected.map {
//            viewModel.dataSourceTypes.value[$0.item]
//        }.bind(to: viewModel.selectedDataSoruceType)
//            .disposed(by: viewModel.disposeBag)
//
//        settingButton.rx.tap.bind {_ in
//            guard TokenRefreshService.isStarted else {
//                viewModel.notAuthorizated.accept(nil)
//                return
//            }
//
//            self.delegate?.didPressSettingsButton()
//        }.disposed(by: viewModel.disposeBag)
//
//
//        self.viewModel = viewModel
    }
}

extension FavoriteViewHeader: UICollectionViewDelegateFlowLayout {
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
//        let text = viewModel!.dataSourceTypes.value[indexPath.item].name
//        let panding = 32.0
//        let width = text.width(constraintedHeight: collectionView.frame.height, font: .systemFont(ofSize: 12, weight: .regular)) + panding
//        return CGSize(width: width, height: collectionView.frame.height)
        return CGSize(width: 0, height: 0)
    }
}

extension FavoriteViewHeader: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredData = subCategories.map { $0.name }
//            tableView.reloadData()
//        } else {
//            filteredData = subCategories.map { $0.name }.filter { $0.lowercased().contains(searchText.lowercased()) }
//        tableView.reloadData()
//        }
    }
}


protocol FavoriteHeaderDelegate: AnyObject {
    func didPressSettingsButton()
}
