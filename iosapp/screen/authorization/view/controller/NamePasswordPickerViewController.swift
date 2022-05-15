//
//  NamePasswordPickerViewController.swift
//  iosapp
//
//  Created by alexander on 13.03.2022.
//

import UIKit
import RxSwift
import SwiftUI

class NamePasswordPickerViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var inputNameDescLabel: UILabel!
    @IBOutlet weak var inputPasswordDescLabel: UILabel!
    @IBOutlet weak var inputPasswordDescTwoLabel: UILabel!
    @IBOutlet weak var inputNameTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var alert: Alert!
    
    // MARK: Properties
    private var phoneNumber: String = ""
    private let viewModel = ViewModelFactory.get(NamePasswordPickerViewModel.self)
    
    // MARK: Processed Properties
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    
    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(closeAuthForm), for: .touchUpInside)
        let closeIcon = #imageLiteral(resourceName: "close_icon")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = .black
        return UIBarButtonItem(customView: closeButton)
    }()
    
    func setup(phone: String) {
        self.phoneNumber = phone
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotifications()
    }

    private func bindViews() {
        // Связывание ввода в поля ввода с элементами модели
        inputNameTextField.rx.text.changed.bind(to: viewModel.name).disposed(by: disposeBag)
        inputPasswordTextField.rx.text.changed.bind(to: viewModel.password).disposed(by: disposeBag)
        
        // Обработка показа/скрытия предупреждения
        viewModel.alert.subscribe(onNext: { alertModel in
            guard let alertModel = alertModel else {
                self.alert.hidden()
                return
            }
            self.alert.show(mode: alertModel.mode, message: alertModel.message)
        }).disposed(by: disposeBag)
        
        // Обработка состояния кнопки продолжить
        viewModel.completeButton.subscribe(onNext: { isEnabled in
            self.completeButton.isEnabled = isEnabled
            UIView.animate(withDuration: 0.3) {
                self.completeButton.alpha = isEnabled ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку продолжить
        completeButton.rx.tap.subscribe { _ in
            self.viewModel.registration(
                phone: self.phoneNumber,
                nameAndSurname: self.inputNameTextField.text!,
                password: self.inputPasswordTextField.text!,
                fingerPrint: UIDevice.current.identifierForVendor!.uuidString
            )
        }.disposed(by: disposeBag)
        
        // Обработка успешной регистрации
        viewModel.registrationComplete.subscribe { _ in
            self.dismiss(animated: true)
            (self.navigationController as? AuthNavigationViewController)?.myDelegate?.didCompleteAuth(isSuccessAuth: true)
        }.disposed(by: disposeBag)
    }
    
    private func configureScreen() {
        view.backgroundColor = Color.backgroundScreen.color
        
        topicLabel.font = .systemFont(ofSize: FontSize.topic.rawValue, weight: .medium)
        topicLabel.textColor = Color.title.color
        
        inputNameDescLabel.font = .systemFont(ofSize: FontSize.inputDesc.rawValue, weight: .regular)
        inputNameDescLabel.textColor = Color.inputDesc.color
        
        inputPasswordDescLabel.font = .systemFont(ofSize: FontSize.inputDesc.rawValue, weight: .regular)
        inputPasswordDescLabel.textColor = Color.inputDesc.color
        
        inputPasswordDescTwoLabel.font = .systemFont(ofSize: FontSize.inputDesc.rawValue, weight: .regular)
        inputPasswordDescTwoLabel.textColor = Color.inputDesc.color
        
        inputPasswordTextField.enablePasswordToggle()
        inputPasswordTextField.layer.cornerRadius = Corner.mainButton.rawValue
        
        inputNameTextField.layer.cornerRadius = Corner.mainButton.rawValue
        
        navigationItem.leftBarButtonItem = closeButton
        
        completeButton.isEnabled = false
        completeButton.alpha = 0.5
        completeButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        completeButton.layer.cornerRadius = Corner.mainButton.rawValue
        
        alert.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputNameTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc
    private func closeAuthForm() {
        dismiss(animated: true)
        (self.navigationController as? AuthNavigationViewController)?.myDelegate?.didCompleteAuth(isSuccessAuth: false)

    }
}


// блок с обработкой клавиатуры
extension NamePasswordPickerViewController {

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        UIView.animate(withDuration: 0.5) {
            self.completeButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 40)
        }
    }

    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 0.5) {
            self.completeButton.transform = .identity
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
