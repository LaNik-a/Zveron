//
//  NumberPickerViewController.swift
//  iosapp
//
//  Created by alexander on 04.03.2022.
//

import UIKit
import InputMask
import RxSwift
import RxCocoa

class PhonePickerViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var subTopicLabel: UILabel!
    @IBOutlet weak var inputMask: NotifyingMaskedTextFieldDelegate!
    @IBOutlet weak var inputPhoneTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var signInByPhoneAndPasswordButton: UIButton!
    @IBOutlet weak var alert: Alert!
    
    // MARK: Properties
    let viewModel = ViewModelFactory.get(PhonePickerViewModel.self)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        configureScreen()
       // registerForKeyboardNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotifications()
    }

//    deinit{
//        removeKeyboardNotifications()
//    }

    private func bindViews() {
        // Обработка успешной отправки кода
        viewModel.sendCode.subscribe { _ in
            let toVC = ControllerFactory.get(CodePickerViewController.self)
            toVC.setUp(phoneNumber: self.inputPhoneTextField.text!)
            self.navigationController?.pushViewController(toVC, animated: true)
        }.disposed(by: disposeBag)
        
        // Обработка состояния кнопки продолжить
        viewModel.continueButtonState.subscribe(onNext: { isEnabled in
            self.continueButton.isEnabled = isEnabled
            UIView.animate(withDuration: 0.3) {
                self.continueButton.alpha = isEnabled ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)
        
        // Обработка состояния поля ввода телефона
        viewModel.phoneTextFieldState
            .map { $0 ? UIColor.black : UIColor.red }
            .bind(to: inputPhoneTextField.rx.textColor)
            .disposed(by: disposeBag)
        
        // Обработка показа/скрытия предупреждения
        viewModel.alert.subscribe(onNext: { errorMessage in
            guard let message = errorMessage else {
                self.alert.hidden()
                return
            }
            self.alert.show(mode: .error, message: message)
        }).disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку продолжить
        continueButton.rx.tap.subscribe { _ in
            self.view.endEditing(true)
            self.viewModel.sendCode(phone: self.inputPhoneTextField.text!)
        }.disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку авторизации по номеру и паролю
        signInByPhoneAndPasswordButton.rx.tap.subscribe { _ in
            self.view.endEditing(true)
            let toVC = ControllerFactory.get(PhonePasswordPickerViewController.self)
            self.navigationController?.pushViewController(toVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func configureScreen() {
        view.backgroundColor = Color.backgroundScreen.color
        topicLabel.font = .systemFont(ofSize: FontSize.topic.rawValue, weight: .medium)
        topicLabel.textColor = Color.title.color
        subTopicLabel.numberOfLines = 0
        subTopicLabel.lineBreakMode = .byWordWrapping
        subTopicLabel.font = .systemFont(ofSize: FontSize.subTopic.rawValue, weight: .regular)
        subTopicLabel.textColor = Color.subTitle.color
        signInByPhoneAndPasswordButton.titleLabel?.font = .systemFont(ofSize: FontSize.subtitle.rawValue, weight: .regular)
        signInByPhoneAndPasswordButton.setTitleColor(Color.subTitle.color, for: .normal)
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        continueButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        continueButton.layer.cornerRadius = Corner.mainButton.rawValue
        alert.configure()
        navigationItem.leftBarButtonItem = closeButton
        inputMask.editingListener = self
        inputMask.affinityCalculationStrategy = .wholeString
        inputMask.affineFormats = ["+7 [000] [000]-[00]-[00]"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputPhoneTextField.becomeFirstResponder()
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

extension PhonePickerViewController: NotifyingMaskedTextFieldDelegateListener {
    func onEditingPhoneChanged(inTextField: UITextField) {
        viewModel.phone.accept(inTextField.text)
    }
}



// блок с обработкой клавиатуры
extension PhonePickerViewController {

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
            self.continueButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 40)

            self.signInByPhoneAndPasswordButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 40)
        }
    }

    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 0.5) {
            self.continueButton.transform = .identity
            self.signInByPhoneAndPasswordButton.transform = .identity
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
