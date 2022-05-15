//
//  AddingLotAddressViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 10.05.2022.
//

import UIKit
import RxSwift

class AddingLotAddressViewController: UIViewController, UITextFieldDelegate {
    
    var lot: Lot = Lot()
    var parameters: [LotParameter] = []
    private var titleAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Адрес"
        return label
    }()
    
    private var subtitleAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.sizeToFit()
        label.text = "Город сделки"
        return label
    }()
    
    private var textFieldAddress: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "Москва"
        textField.textAlignment = .left
        return textField
    }()
    
    private var titleContacts: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Способы связи"
        return label
    }()
    
    private var viewPhone: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = .gray
        return view
    }()
    
    private var viewTitlePhone: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        label.text = "По телефону"
        return label
    }()
    
    private var viewChat: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = .gray
        return view
    }()
    
    private var viewTitleChat: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        label.text = "По сообщениям"
        return label
    }()
    
    
    private var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    private var alert: Alert = {
        let al = Alert()
        al.translatesAutoresizingMaskIntoConstraints = false
        return al
    }()
    
    let navBtn = NavigationButton.back.button
    
    private let viewModel = ViewModelFactory.get(AddingLotAddressViewModel.self)
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViews()
    }
    
    func setUp() {
        textFieldAddress.delegate = self
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        
        self.view.addSubview(titleAddress)
        titleAddress.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        titleAddress.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        titleAddress.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        
        self.view.addSubview(subtitleAddress)
        subtitleAddress.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        subtitleAddress.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        subtitleAddress.topAnchor.constraint(equalTo: self.titleAddress.bottomAnchor, constant: 16).isActive = true
        
        self.view.addSubview(textFieldAddress)
        textFieldAddress.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        textFieldAddress.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        textFieldAddress.topAnchor.constraint(equalTo: self.subtitleAddress.bottomAnchor, constant: 6).isActive = true
        
        self.view.addSubview(alert)
        alert.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        alert.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        alert.topAnchor.constraint(equalTo: self.textFieldAddress.bottomAnchor, constant: 6).isActive = true
        
        self.view.addSubview(titleContacts)
        titleContacts.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        titleContacts.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        titleContacts.topAnchor.constraint(equalTo: self.textFieldAddress.bottomAnchor, constant: 40).isActive = true
        
        
        self.view.addSubview(viewPhone)
        viewPhone.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        viewPhone.topAnchor.constraint(equalTo: self.titleContacts.bottomAnchor, constant: 16).isActive = true
        viewPhone.heightAnchor.constraint(equalToConstant: 17).isActive = true
        viewPhone.widthAnchor.constraint(equalToConstant: 17).isActive = true
        
        self.view.addSubview(viewTitlePhone)
        viewTitlePhone.leftAnchor.constraint(equalTo: self.viewPhone.rightAnchor, constant: 8).isActive = true
        viewTitlePhone.topAnchor.constraint(equalTo: self.titleContacts.bottomAnchor, constant: 15).isActive = true
        
        self.view.addSubview(viewChat)
        viewChat.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        viewChat.topAnchor.constraint(equalTo: self.viewTitlePhone.bottomAnchor, constant: 30).isActive = true
        viewChat.heightAnchor.constraint(equalToConstant: 17).isActive = true
        viewChat.widthAnchor.constraint(equalToConstant: 17).isActive = true
        
        self.view.addSubview(viewTitleChat)
        viewTitleChat.leftAnchor.constraint(equalTo: self.viewChat.rightAnchor, constant: 8).isActive = true
        viewTitleChat.topAnchor.constraint(equalTo: self.viewTitlePhone.bottomAnchor, constant: 29).isActive = true
        
        
        
        self.view.addSubview(continueButton)
        continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        continueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        alert.configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
    }
    
    func bindViews() {
        textFieldAddress.rx.text.changed.bind(to: viewModel.addressLot).disposed(by: disposeBag)
        let gesturePhone = UITapGestureRecognizer(target: self, action: #selector(tapPhoneView))
        self.viewPhone.addGestureRecognizer(gesturePhone)
        
        let gestureChat = UITapGestureRecognizer(target: self, action: #selector(tapChatView))
        self.viewChat.addGestureRecognizer(gestureChat)
        
        viewModel.isPhone.distinctUntilChanged().bind(onNext: { isPhone in
            if isPhone {
                self.viewPhone.applyGradient(.mainButton, .horizontal, 4)
            } else {
                self.viewPhone.removeGradientLayer(layerIndex: 0)
            }
        }).disposed(by: disposeBag)
        
        viewModel.isChat.distinctUntilChanged().bind(onNext: { isChat in
            if isChat {
                self.viewChat.applyGradient(.mainButton, .horizontal, 4)
            } else {
                self.viewChat.removeGradientLayer(layerIndex: 0)
            }
        }).disposed(by: disposeBag)
        
        viewModel.continueBtn.bind(onNext: { isEnabled in
            self.continueButton.isEnabled = isEnabled
            UIView.animate(withDuration: 0.3) {
                self.continueButton.alpha = isEnabled ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)
        
        // Обработка показа/скрытия предупреждения
        viewModel.alert.bind(onNext: { alertModel in
            guard let alertModel = alertModel else {
                self.alert.hidden()
                return
            }
            self.alert.show(mode: alertModel.mode, message: alertModel.message)
        }).disposed(by: disposeBag)
        
        continueButton.rx.tap.bind(onNext: {
            let contact = Contact(phone: self.viewModel.isPhone.value, facebook: false, vk: false, email: false, chat: self.viewModel.isChat.value)
            let val = self.viewModel.addressLot.value!
            let address = Address(region: "Россия", district: val, town: val, street: "Варшавская", house: "144", longitude: 0, latitude: 0)
            // обрабатывать номер телефона (он может быть не указан в профиле)
            self.lot.contact = contact
            self.lot.address = address
            print(self.lot)
            self.viewModel.createLot(lot: self.lot)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    @objc func tapPhoneView(sender : UITapGestureRecognizer) {
        let currentValue = self.viewModel.isPhone.value
        self.viewModel.isPhone.accept(!currentValue)
    }
    
    @objc func tapChatView(sender : UITapGestureRecognizer) {
        let currentValue = self.viewModel.isChat.value
        self.viewModel.isChat.accept(!currentValue)
    }
}

extension AddingLotAddressViewController: SetLotProtocol {
    func setLot(_ lot: Lot, parameters: [LotParameter]) {
        self.lot = lot
        self.parameters = parameters
    }
}
