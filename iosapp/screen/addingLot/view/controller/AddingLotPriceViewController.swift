//
//  AddingLotPriceViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 10.05.2022.
//

import UIKit
import RxSwift
class AddingLotPriceViewController: UIViewController, UITextFieldDelegate {
    
    var lot: Lot = Lot()
    var parameters: [LotParameter] = []
    
    private var titlePrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Укажите цену"
        return label
    }()
    
    private var subtitlePrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.sizeToFit()
        label.text = "Цена"
        return label
    }()
    
    private var textFieldPrice: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "₽"
        textField.textAlignment = .left
        return textField
    }()
    
    private var viewPrice: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = .gray
        return view
    }()
    
    private var viewTitlePrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Цена договорная"
        return label
    }()
    
    private var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Далее", for: .normal)
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
    
    private let viewModel = ViewModelFactory.get(AddingLotPriceViewModel.self)
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViews()
    }
    
    func setUp() {
        textFieldPrice.delegate = self
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        
        self.view.addSubview(titlePrice)
        titlePrice.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        titlePrice.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        titlePrice.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        
        self.view.addSubview(subtitlePrice)
        subtitlePrice.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        subtitlePrice.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        subtitlePrice.topAnchor.constraint(equalTo: self.titlePrice.bottomAnchor, constant: 16).isActive = true
        
        self.view.addSubview(textFieldPrice)
        textFieldPrice.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        textFieldPrice.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        textFieldPrice.topAnchor.constraint(equalTo: self.subtitlePrice.bottomAnchor, constant: 6).isActive = true
        
        self.view.addSubview(alert)
        alert.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        alert.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        alert.topAnchor.constraint(equalTo: self.textFieldPrice.bottomAnchor, constant: 6).isActive = true
        
        
        self.view.addSubview(viewPrice)
        viewPrice.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        viewPrice.topAnchor.constraint(equalTo: self.textFieldPrice.bottomAnchor, constant: 50).isActive = true
        viewPrice.heightAnchor.constraint(equalToConstant: 17).isActive = true
        viewPrice.widthAnchor.constraint(equalToConstant: 17).isActive = true
        
        self.view.addSubview(viewTitlePrice)
        viewTitlePrice.leftAnchor.constraint(equalTo: self.viewPrice.rightAnchor, constant: 8).isActive = true
        viewTitlePrice.topAnchor.constraint(equalTo: self.textFieldPrice.bottomAnchor, constant: 49).isActive = true
        
        
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
        textFieldPrice.rx.text.changed.bind(to: viewModel.priceLot).disposed(by: disposeBag)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapPriceView))
        self.viewPrice.addGestureRecognizer(gesture)
        
        viewModel.isSpecificPrice.distinctUntilChanged().bind(onNext: { isSpecificPrice in
            if isSpecificPrice {
                self.viewPrice.applyGradient(.mainButton, .horizontal, 4)
                self.textFieldPrice.text = ""
                self.textFieldPrice.isUserInteractionEnabled = false
                self.alert.hidden()
            } else {
                self.viewPrice.removeGradientLayer(layerIndex: 0)
                self.textFieldPrice.isUserInteractionEnabled = true
            }
            UIView.animate(withDuration: 0.3) {
                self.textFieldPrice.alpha = isSpecificPrice ? 0.5 : 1.0
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
            let vc = AddingLotAddressViewController()
            if self.viewModel.priceLot.value != nil {
                self.lot.price = Int(self.viewModel.priceLot.value!)
            }
            vc.setLot(self.lot, parameters: self.parameters)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    @objc func tapPriceView(sender : UITapGestureRecognizer) {
        let currentValue = self.viewModel.isSpecificPrice.value
        self.viewModel.isSpecificPrice.accept(!currentValue)
    }
    
}

extension AddingLotPriceViewController: SetLotProtocol {
    func setLot(_ lot: Lot, parameters: [LotParameter]) {
        self.lot = lot
        self.parameters = parameters
    }
}
