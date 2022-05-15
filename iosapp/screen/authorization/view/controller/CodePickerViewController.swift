//
//  TokenPickerViewController.swift
//  iosapp
//
//  Created by alexander on 12.03.2022.
//

import UIKit
import RxSwift

class CodePickerViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var topicDescLabel: UILabel!
    @IBOutlet weak var reGetCodeButton: UIButton!
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    @IBOutlet weak var signInByPhoneAndPasswordButton: UIButton!
    @IBOutlet weak var alert: Alert!
    
    // MARK: Properties
    private let viewModel = ViewModelFactory.get(CodePickerViewModel.self)
    private var phoneNumber: String = ""
    
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
    
    func setUp(phoneNumber: String) {
        self.phoneNumber = phoneNumber
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
        // Обработка успешного результата проверки кода
        viewModel.checkCode.subscribe(onNext: { status in
            switch status {
            case .loginSuccess:
                self.dismiss(animated: true)
                (self.navigationController as? AuthNavigationViewController)?.myDelegate?.didCompleteAuth(isSuccessAuth: true)
            case .needRegistration:
                self.view.endEditing(true)
                let toVC = ControllerFactory.get(NamePasswordPickerViewController.self)
                toVC.setup(phone: self.phoneNumber)
                self.navigationController?.pushViewController(toVC, animated: true)
            }
        }).disposed(by: disposeBag)
        
        // Обработка состояний текстового поля по вводу кода
        viewModel.codeTextFieldState.subscribe(onNext: { isValid in
            if isValid {
                self.codeTextField.setNormalState()
            } else {
                self.codeTextField.setErrorState()
            }
        }).disposed(by: disposeBag)
        
        // Обработка состояний предупреждения текстового поля по вводу кода
        viewModel.alert.subscribe(onNext: { errorMessage in
            guard let message = errorMessage else {
                self.alert.hidden()
                return
            }
            self.alert.show(mode: .error, message: message)
        }).disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку продолжить
        reGetCodeButton.rx.tap.subscribe { _ in
            let countdown = 30
            self.viewModel.reSendCode(phone: self.phoneNumber)
            Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .map { countdown - $0 }
                .take(until: { $0 == 0 }, behavior: .inclusive)
                .subscribe(onNext: { value in
                    // иизменение кнопки
                    if value != 0 {
                        self.reGetCodeButton.setTitle("Запросить повторно через \(value)c", for: .disabled)
                        self.reGetCodeButton.isEnabled = false
                    } else {
                        self.reGetCodeButton.isEnabled = true
                    }
                }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку "войти по номеру и паролю"
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
        
        topicDescLabel.text? += phoneNumber
        topicDescLabel.numberOfLines = 0
        topicDescLabel.lineBreakMode = .byWordWrapping
        topicDescLabel.font = .systemFont(ofSize: FontSize.subTopic.rawValue, weight: .light)
        topicDescLabel.textColor = Color.title.color
        
        reGetCodeButton.titleLabel?.font = .systemFont(ofSize: FontSize.subtitle.rawValue, weight: .regular)
        reGetCodeButton.setTitle("Запросить повторно", for: .normal)
        // Градиент цвет поставить
        reGetCodeButton.setTitleColor(.orange, for: .normal)
        reGetCodeButton.setTitleColor(Color.subTitle.color, for: .disabled)
        
        signInByPhoneAndPasswordButton.titleLabel?.font = .systemFont(ofSize: FontSize.subtitle.rawValue, weight: .regular)
        signInByPhoneAndPasswordButton.setTitleColor(Color.subTitle.color, for: .normal)
        
        navigationItem.leftBarButtonItem = backButton
        
        alert.configure()
        
        codeTextField.configure(with: 4)
        codeTextField.didEnterFirstDigit = { [weak self] _ in
            self?.viewModel.setErrorScreenState.accept(nil)
        }
        codeTextField.didEnterLastDigit = { [weak self] code in
            guard let self = self else { return }
            self.viewModel.checkCode(
                phone: self.phoneNumber,
                code: code,
                fingerPrint: UIDevice.current.identifierForVendor!.uuidString
            )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        codeTextField.becomeFirstResponder()
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


// блок с обработкой клавиатуры
extension CodePickerViewController {

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
            self.signInByPhoneAndPasswordButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 40)
        }
    }

    @objc private func keyboardWillHide() {
        UIView.animate(withDuration: 0.5) {
            self.signInByPhoneAndPasswordButton.transform = .identity
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
