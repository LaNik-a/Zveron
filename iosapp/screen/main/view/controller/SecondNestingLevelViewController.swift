//
//  SecondLevelCategoryViewController.swift
//  iosapp
//
//  Created by alexander on 03.05.2022.
//

import Foundation
import BottomSheet
import RxSwift
import RxCocoa
import Kingfisher
import RxDataSources
import RemoteDataService

class SecondNestingLevelViewController: UIViewController {
    private var transitionDelegate: UIViewControllerTransitioningDelegate?

    private let viewModel = ViewModelFactory.get(SecondNestingViewModel.self)
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }

    private lazy var collectionView: LotCollectionView = {
        let collectionView = LotCollectionView(frame: view.frame)
        collectionView.backgroundColor = Color.backgroundScreen.color
        collectionView.setHeaderSize(size: CGSize(width: view.frame.width, height: 240))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var header: SecondNestingHeader = {
        let view = SecondNestingHeader(frame: view.frame)
        view.backgroundColor = Color.backgroundScreen.color
        view.safeArea = 60
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Поиск"
        searchBar.showsBookmarkButton = true
        let icon = #imageLiteral(resourceName: "settings_icon")
        searchBar.setImage(icon, for: .bookmark, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .clear)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .bookmark)
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var backButton: UIBarButtonItem = {
        let backButton = UIButton(type: .system)
        backButton.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        let backIcon = #imageLiteral(resourceName: "back_icon")
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = .black
        return UIBarButtonItem(customView: backButton)
    }()

    override func viewDidLayoutSubviews() {
        header.setupAnchorView(navigationController?.navigationBar)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.filter.accept(viewModel.filter.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusBar()
        configureScreen()
        bindViews()
        view.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.backgroundColor = Color.backgroundScreen.color
    }

    private func configureStatusBar() {
        let statusBar = UIView()
        let height =  UIApplication.shared.statusBarFrame.height
        statusBar.frame = CGRect(x: 0, y: -height, width: view.frame.width, height: height)
        statusBar.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.addSubview(statusBar)
    }

    private func configureScreen() {
        navigationItem.leftBarButtonItem = backButton
        view.addSubview(collectionView)
        view.addSubview(header)
        let margin = view.layoutMarginsGuide
        header.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 240).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.titleView = searchBar
    }

    private func bindViews() {
        collectionView.bindViews(viewModel)
        header.bindViews(viewModel)

        viewModel.needShowAllSubCategories.bind(onNext: {_ in 
            let toVC = SinglePickerViewController(isBackButton: false)
            toVC.setup(
                topic: self.viewModel.filter.value.category!.name,
                categories: self.viewModel.subCategories.value
            )
            toVC.delegate = self

            let navVC = UINavigationController(rootViewController: toVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }).disposed(by: disposeBag)

        viewModel.selectedSubCategory.bind(onNext: { subCategory in
            let oldFilter = self.viewModel.filter.value
            let newFilter = FilterModel(
                sortingType: oldFilter.sortingType,
                category: oldFilter.category,
                subCategory: subCategory,
                parameters: oldFilter.parameters
            )
            let toVC = ThirdNestingLevelViewController()
            toVC.setupData(presentationMode: self.viewModel.presentationModeType.value, filter: newFilter)
            self.navigationController?.pushViewController(toVC, animated: true)
        }).disposed(by: disposeBag)
    }

    func setupData(presentationMode: PresentModeType, filter: FilterModel) {
        viewModel.filter.accept(filter)
        viewModel.sortingType.accept(filter.sortingType)
        viewModel.presentationModeType.accept(presentationMode)
        viewModel.getSubCategories(category: filter.category!)
    }
}

extension SecondNestingLevelViewController: SinglePickerDelegate {
    func willFinish(subCategory: Category) {
        viewModel.selectedSubCategory.accept(subCategory)
    }
}

extension SecondNestingLevelViewController: BottomSheetModalDismissalHandler, BottomSheetPresentationControllerFactory {
    var canBeDismissed: Bool { true }

    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }

    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
        .init(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self
        )
    }
}

extension SecondNestingLevelViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let vc =  FilterViewController()
        vc.setup(presentMode: viewModel.presentationModeType.value, filter: viewModel.filter.value)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

extension SecondNestingLevelViewController: FilterViewDelegate {
    func willFinish(presentMode: PresentModeType, filter: FilterModel) {
        if filter.subCategory == nil {
            viewModel.presentationModeType.accept(presentMode)
            viewModel.sortingType.accept(filter.sortingType)
            viewModel.getSubCategories(category: filter.category!)
            viewModel.filter.accept(filter)
        } else {
            let toVC = ThirdNestingLevelViewController()
            toVC.setupData(presentationMode: presentMode, filter: filter)
            navigationController?.pushViewController(toVC, animated: false)
        }
    }
}
