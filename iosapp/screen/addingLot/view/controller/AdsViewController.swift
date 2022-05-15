//
//  AdsViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 28.04.2022.
//

import UIKit
import BottomSheet
import RxSwift

class AdsViewController: UIViewControllerWithAuth {
    private let viewModel = ViewModelFactory.get(AdsViewModel.self)
    
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViews()
    }
    
    private let addLotBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func bindViews() {
        addLotBtn.rx.tap.subscribe { _ in
            self.viewModel.checkLogInUser()
        }.disposed(by: disposeBag)
        
        viewModel.isAuthorized.subscribe(onNext: { isAuthorized in
            if isAuthorized {
                self.presentAddingLotController()
            } else {
                self.presentAuthController()
            }
        }).disposed(by: disposeBag)
    }
    
    func setUp() {
        addLotBtn.layer.cornerRadius = Corner.mainButton.rawValue
        addLotBtn.setTitle("Добавить объявление", for: .normal)
        addLotBtn.contentHorizontalAlignment = .center
        addLotBtn.setTitleColor(.white, for: .normal)
        self.view.backgroundColor = Color.backgroundScreen.color
        view.addSubview(addLotBtn)
        addLotBtn.heightAnchor.constraint(equalToConstant: 52).isActive = true
        addLotBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
        addLotBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        addLotBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addLotBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
    }
    
    private func presentAddingLotController() {
        let addingLotVC = ControllerFactory.get(AddingLotViewController.self)
        let navAddingLotVC = UINavigationController(rootViewController: addingLotVC)
        navAddingLotVC.modalPresentationStyle = .fullScreen
        self.present(navAddingLotVC, animated: true, completion: nil)
    }
    
    private func presentAuthController() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Вы не авторизованы",
                message: "Для добавления объявления пройдите авторизацию",
                preferredStyle: .alert
            )
            let okAlertAction = UIAlertAction(title: "ОК", style: .default, handler: {_ in
                self.presentAutharication()
//                let newVC = MainAuthViewController()
//                let navigationController = BottomSheetNavigationController(rootViewController: newVC)
//                self.transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
//                navigationController.transitioningDelegate = self.transitionDelegate
//                navigationController.modalPresentationStyle = .custom
//                self.present(navigationController, animated: true, completion: nil)
            })
            alert.addAction(okAlertAction)
            self.present(alert, animated: true)
        }
    }
    
}
