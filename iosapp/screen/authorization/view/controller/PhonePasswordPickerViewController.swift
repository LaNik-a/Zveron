//
//  NumberPasswordPickerViewController.swift
//  iosapp
//
//  Created by alexander on 11.03.2022.
//

import UIKit
import Alamofire
import RxSwift
import RxRelay
import InputMask

class PhonePasswordPickerViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var inputPhoneDescLabel: UILabel!
    @IBOutlet weak var inputPasswordDescLabel: UILabel!
    @IBOutlet weak var inputMask: NotifyingMaskedTextFieldDelegate!
    @IBOutlet weak var inputPhoneTextField: UITextField!
    @IBOutlet weak var inputPasswordTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var alert: Alert!
    
    // MARK: Properties
    private let viewModel = ViewModelFactory.get(PhonePasswordPickerViewModel.self)
    
    // MARK: Processed Properties
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    
    private lazy var backButton: UIBarButtonItem = {
        let backButton = UIButton(type: .system)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backIcon = #imageLiteral(resourceName: "back_icon")
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = .black
        return UIBarButtonItem(customView: backButton)
    }()
    
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
        // связывание поля ввода пароля с полем модели
        inputPasswordTextField.rx.text.changed.bind(to: viewModel.password).disposed(by: disposeBag)
        
        // Обработка показа/скрытия предпреждения
        viewModel.alert.subscribe(onNext: { [weak self] alertModel in
            guard let alertModel = alertModel else {
                self?.alert.hidden()
                return
            }
            self?.alert.show(mode: alertModel.mode, message: alertModel.message)
        }).disposed(by: disposeBag)
        
        // Обработка состояния кнопки продолжить
        viewModel.completeButton.subscribe(onNext: { isEnabled in
            self.completeButton.isEnabled = isEnabled
            UIView.animate(withDuration: 0.3) {
                self.completeButton.alpha = isEnabled ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)
        
        // Обработка нажатия кнопки продолжить
        completeButton.rx.tap.subscribe { _ in
            self.viewModel.signIn(
                phone: self.inputPhoneTextField.text!,
                password: self.inputPasswordTextField.text!,
                fingerPrint: UIDevice.current.identifierForVendor!.uuidString
            )
        }.disposed(by: disposeBag)
        
        // Обработка успешной авторизации
        viewModel.signIn.subscribe { _ in
            self.dismiss(animated: true)
            (self.navigationController as? AuthNavigationViewController)?.myDelegate?.didCompleteAuth(isSuccessAuth: true)
        }.disposed(by: disposeBag)
    }
    
    private func configureScreen() {
        view.backgroundColor = Color.backgroundScreen.color
        topicLabel.font = .systemFont(ofSize: FontSize.topic.rawValue, weight: .medium)
        topicLabel.textColor = Color.title.color
        inputPhoneDescLabel.font = .systemFont(ofSize: FontSize.inputDesc.rawValue, weight: .regular)
        inputPhoneDescLabel.textColor = Color.inputDesc.color
        inputPasswordDescLabel.font = .systemFont(ofSize: FontSize.inputDesc.rawValue, weight: .regular)
        inputPasswordDescLabel.textColor = Color.inputDesc.color
        inputPasswordTextField.enablePasswordToggle()
        navigationItem.leftBarButtonItem = backButton
        completeButton.isEnabled = false
        completeButton.alpha = 0.5
        completeButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        completeButton.layer.cornerRadius = Corner.mainButton.rawValue
        inputMask.affinityCalculationStrategy = .wholeString
        inputMask.affineFormats = ["+7 [000] [000]-[00]-[00]"]
        inputMask.editingListener = self
        alert.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputPhoneTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc
    private func back() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}

extension PhonePasswordPickerViewController: NotifyingMaskedTextFieldDelegateListener {
    func onEditingPhoneChanged(inTextField: UITextField) {
        viewModel.phone.accept(inTextField.text)
    }
}

// блок с обработкой клавиатуры
extension PhonePasswordPickerViewController {

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
