//
//  AUTH.swift
//  iosapp
//
//  Created by alexander on 11.05.2022.
//

import Foundation
import UIKit
import BottomSheet
import RemoteDataService
import RxCocoa
import RxSwift

class AuthNavigationViewController: UINavigationController {
    var myDelegate: AuthCompleteDelegate?
}

class UIViewControllerWithAuth: UIViewController {
    private var transitionDelegate: UIViewControllerTransitioningDelegate?
    private var pickerController: BottomSheetNavigationController?
    private let authViewModel = ViewModelFactory.get(MainAuthViewModel.self)
    private var authDisposeBag: DisposeBag {
        return authViewModel.disposeBag
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
    }

    private func bindViews() {
        authViewModel.signInByMessenger.subscribe(onNext: { success in
            self.didCompleteAuth(isSuccessAuth: success)
            if !success {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Ошибка",
                        message: "При авторизации через соц-сеть произошла ошибка",
                        preferredStyle: .alert
                    )
                    let okAlertAction = UIAlertAction(title: "ОК", style: .default)
                    alert.addAction(okAlertAction)
                    self.present(alert, animated: true)
                }
            }
        }).disposed(by: authDisposeBag)
    }
   func presentAutharication() {
       let authVC = MainAuthViewController()
       let navigationController = BottomSheetNavigationController(rootViewController: authVC)
       self.transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
       authVC.delegate = self
       pickerController = navigationController
       navigationController.transitioningDelegate = self.transitionDelegate
       navigationController.modalPresentationStyle = .custom
       self.present(navigationController, animated: true)
    }
}

extension UIViewControllerWithAuth: BottomSheetModalDismissalHandler, BottomSheetPresentationControllerFactory {
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

extension UIViewControllerWithAuth: AuthPickerDelegate {
    func didClickGoogle() {
        let vc = AuthWebViewController()
        vc.setUp(
            delegate: self,
            startUrl: "\(RemoteDataConstant.BASE_URL)/oauth2/authorization/google",
            modifiedRequestUrl: "\(RemoteDataConstant.BASE_URL)/login/oauth2/code/google?"
        )
        self.presentController(toVC: vc)
    }

    func didClickVk() {
        let vc = AuthWebViewController()
        vc.setUp(
            delegate: self,
            startUrl: "\(RemoteDataConstant.BASE_URL)/oauth2/authorization/vk",
            modifiedRequestUrl: "\(RemoteDataConstant.BASE_URL)/login/oauth2/code/vk?"
        )
        self.presentController(toVC: vc)
    }

    func didClickAuthByPhone() {
        let vc = ControllerFactory.get(PhonePickerViewController.self)
        self.presentController(toVC: vc)
    }

    private func presentController(toVC: UIViewController) {
        let navigation = AuthNavigationViewController(rootViewController: toVC)
        navigation.myDelegate = self
        navigation.modalPresentationStyle = .fullScreen
        self.pickerController?.dismiss(animated: true, completion: {
            self.present(navigation, animated: true)
        })
    }
}

extension UIViewControllerWithAuth: AuthWebViewDelegate {
    func didFinish(url: URL) {
        authViewModel.signInByMessenger(url: url, fingerPrint: UIDevice.current.identifierForVendor!.uuidString)
    }
}

extension UIViewControllerWithAuth: AuthCompleteDelegate {
    func didCompleteAuth(isSuccessAuth: Bool) { }
}

protocol AuthCompleteDelegate: AnyObject {
    func didCompleteAuth(isSuccessAuth: Bool)
}
