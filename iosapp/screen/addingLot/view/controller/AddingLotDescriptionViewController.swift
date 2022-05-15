//
//  AddingLotDescriptionViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 09.05.2022.
//

import UIKit
import RxSwift
import RxCocoa


class AddingLotDescriptionViewController: UIViewController, UITextViewDelegate {
    
    var lot: Lot = Lot()
    var parameters: [LotParameter] = []
    
    private var titleDesc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Опишите товар"
        return label
    }()
    
    private var subtitleDesc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.sizeToFit()
        label.text = "Описание"
        return label
    }()
    
    private var textFieldAge: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.placeholder = "Выберите дату рождения"
        textField.textAlignment = .left
        return textField
    }()
    
    private var textFieldView: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.isEditable = true
        return textField
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
    
    private let viewModel = ViewModelFactory.get(AddingLotDescriptionViewModel.self)
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldAge.setInputViewDatePicker(target: self, selector: #selector(donePressed))
        self.hideKeyboardWhenTappedAround()
        setUp()
        bindViews()
    }
    
    func bindViews() {
        textFieldAge.rx.text.changed.bind(to: viewModel.ageLot).disposed(by: disposeBag)
        textFieldView.rx.text.changed.bind(to: viewModel.descLot).disposed(by: disposeBag)
        // Обработка состояния кнопки продолжить
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
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        continueButton.rx.tap.bind(onNext: {
            self.lot.description = self.viewModel.descLot.value
            
            let id = self.parameters.filter({$0.name == "Возраст"}).first?.id
            
            if self.viewModel.ageLot.value != nil {
                self.lot.parameters?.append(DopParamsLot(id: id!, value: self.viewModel.ageLot.value!))
            }
            let vc = AddingLotPriceViewController()
            vc.setLot(self.lot, parameters: self.parameters)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }
                                
    @objc func donePressed() {
        if let datePicker = self.textFieldAge.inputView as? UIDatePicker {
            let dateformatter =  ISO8601DateFormatter()
            //dateformatter.dateStyle = .medium
            self.textFieldAge.text = dateformatter.string(from: datePicker.date)
        }
        self.textFieldAge.resignFirstResponder()
    }
    
    func setUp() {
        textFieldAge.delegate = self
        textFieldView.delegate = self
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        
        self.view.addSubview(titleDesc)
        titleDesc.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        titleDesc.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        titleDesc.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        
        self.view.addSubview(subtitleDesc)
        subtitleDesc.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        subtitleDesc.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        subtitleDesc.topAnchor.constraint(equalTo: self.titleDesc.bottomAnchor, constant: 16).isActive = true
        
        self.view.addSubview(textFieldView)
        textFieldView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        textFieldView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        textFieldView.topAnchor.constraint(equalTo: self.subtitleDesc.bottomAnchor, constant: 16).isActive = true
        textFieldView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        self.view.addSubview(alert)
        alert.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        alert.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        alert.topAnchor.constraint(equalTo: self.textFieldView.bottomAnchor, constant: 6).isActive = true
        
        self.view.addSubview(textFieldAge)
        textFieldAge.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        textFieldAge.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        textFieldAge.topAnchor.constraint(equalTo: self.textFieldView.bottomAnchor, constant: 60).isActive = true
        
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
    
}

extension AddingLotDescriptionViewController: SetLotProtocol {
    func setLot(_ lot: Lot, parameters: [LotParameter]) {
        self.lot = lot
        self.parameters = parameters
    }
}

extension AddingLotDescriptionViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddingLotDescriptionViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension AddingLotDescriptionViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }
    
}
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date().from(year: 1800, month: 01, day: 01)
        datePicker.maximumDate = Date()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // потом сделать не системные кнопки 
        let cancel = UIBarButtonItem(title: "Отменить", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
