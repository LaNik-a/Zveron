//
//  FavoriteViewController.swift
//  iosapp
//
//  Created by alexander on 30.04.2022.
//

import UIKit
import BottomSheet
import RxSwift
import RxCocoa
import RxDataSources
import RemoteDataService

class FavoriteViewController: UIViewController {
    private var transitionDelegate: UIViewControllerTransitioningDelegate?

    private let viewModel = ViewModelFactory.get(FavoriteViewModel.self)
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }

    private lazy var header: FavoriteViewHeader = {
        let header = FavoriteViewHeader()
        header.delegate = self
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private var collectionView: LotCollectionView = {
        let collection = LotCollectionView()
        collection.setHeaderSize()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusBar()
        configureScreen()
        bindViews()
        view.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.backgroundColor = Color.backgroundScreen.color
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//           viewModel.selectedDataSoruceType.accept(viewModel.selectedDataSoruceType.value)
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.resetDataSources()
    }

    private func configureStatusBar() {
        let statusBar = UIView()
        let height =  UIApplication.shared.statusBarFrame.height
        statusBar.frame = CGRect(x: 0, y: -height, width: view.frame.width, height: height)
        statusBar.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.addSubview(statusBar)
    }

    private func configureScreen() {
        let margin = view.layoutMarginsGuide
        view.addSubview(header)
        view.addSubview(collectionView)

        header.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: view.frame.height / 5).isActive = true

        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func bindViews() {
        header.bindViews(viewModel)
        collectionView.bindViews(viewModel, self)
    }
}

extension FavoriteViewController: BottomSheetModalDismissalHandler, BottomSheetPresentationControllerFactory {
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

extension FavoriteViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let lotId = (interaction.view as? LotCell)?.viewModel.data.value?.id

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            // Creating Save button


            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash.fill"), attributes: .destructive) {_ in
//                self.viewModel.deleteLot(lotId: lotId!, isAccept: true)
            }

            // Creating main context menu
            return  UIMenu.init(title: "Меню", children: [delete])
        }
        return configuration


    }


}

extension FavoriteViewController: FavoriteHeaderDelegate {
    func didPressSettingsButton() {
        DispatchQueue.main.async {

            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

//            let deleteAll = UIAlertAction(title: "Удалить все", style: .destructive, handler: {_ in self.viewModel.deleteAllLots()})
//
//            let deleteNotActive = UIAlertAction(title: "Удалить неактивные", style: .default, handler: {_ in self.viewModel.deleteNotActiveLots()})

            let cancel = UIAlertAction(title: "Отмена", style: .cancel)

//            alert.addAction(deleteNotActive)
//            alert.addAction(deleteAll)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
}
