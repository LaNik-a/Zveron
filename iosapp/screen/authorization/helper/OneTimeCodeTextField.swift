//
//  OneTimeCodeTextField.swift
//  iosapp
//
//  Created by alexander on 12.03.2022.
//

import UIKit

class OneTimeCodeTextField: UITextField {
    var didEnterLastDigit: ((String) -> Void)?
    var didEnterFirstDigit: ((String) -> Void)?

    private var isConfigured = false
    private var digitLabels = [UILabel]()
    private var placeHolderLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure (with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configuredTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setErrorState() {
        self.text = ""
        digitLabels.forEach { label in
            label.text = ""
        }
        
        placeHolderLabels.forEach { label in
            label.backgroundColor = .red
            label.animateErrorState(transLeft: -40, transRight: 40, duration: 0.5)
        }
    }
    
    func setNormalState() {
        placeHolderLabels.forEach { label in
            label.backgroundColor = .black
        }
    }
    
    private func configuredTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = self.bounds.width / 10.0
        
        for _ in 1...count {
            let tokenBlockView = UIView()
            tokenBlockView.translatesAutoresizingMaskIntoConstraints = false
            
            // Настройка вводимых цифр
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20)
            label.isUserInteractionEnabled = true
            
            // Настройка подставок для цифр
            let placeHolderLabel = UILabel()
            placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
            placeHolderLabel.backgroundColor = .darkGray
            placeHolderLabel.isUserInteractionEnabled = true
            placeHolderLabel.layer.opacity = 0.8
            
            tokenBlockView.addSubview(label)
            tokenBlockView.addSubview(placeHolderLabel)
            
            // Настрока связей для tokenBlockView с цифрой и подставкой
            tokenBlockView.addConstraints([
                label.topAnchor.constraint(equalTo: tokenBlockView.topAnchor),
                label.leadingAnchor.constraint(equalTo: tokenBlockView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: tokenBlockView.trailingAnchor)
            ])
            
            tokenBlockView.addConstraints([
                placeHolderLabel.leadingAnchor.constraint(equalTo: tokenBlockView.leadingAnchor),
                placeHolderLabel.trailingAnchor.constraint(equalTo: tokenBlockView.trailingAnchor),
                placeHolderLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8)
            ])
            
            label.addConstraint(label.heightAnchor.constraint(equalToConstant: 20))
            placeHolderLabel.addConstraint(placeHolderLabel.heightAnchor.constraint(equalToConstant: 2))
            placeHolderLabel.layer.cornerRadius = 4
            
            stackView.addArrangedSubview(tokenBlockView)
            digitLabels.append(label)
            placeHolderLabels.append(placeHolderLabel)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0..<digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text?.removeAll()
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
        if text.count == 1 {
            didEnterFirstDigit?(text)
        }
    }
}

private extension UILabel {
    func animateErrorState(transLeft: CGFloat, transRight: CGFloat, duration: CGFloat) {
        let transLeft = CGAffineTransform.init(translationX: transLeft, y: 0)
        let transRight = CGAffineTransform.init(translationX: transRight, y: 0)
        let animateDuration = duration / 3
        
        UIView.animate(withDuration: animateDuration) {
            self.transform = transRight
        }
        
        UIView.animate(withDuration: animateDuration, delay: animateDuration) {
            self.transform = transLeft
        }
        
        UIView.animate(withDuration: animateDuration, delay: 2 * animateDuration) {
            self.transform = .identity
        }
    }
}

extension OneTimeCodeTextField: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
