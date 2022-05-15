//
//  Alert.swift
//  iosapp
//
//  Created by alexander on 24.04.2022.
//

import Foundation
import UIKit

class Alert: UIView {
    private var isConfigured = false
    private var isUpdatedText = false
    private var label = UILabel()
    private var imageView = UIImageView()
    private let icon = #imageLiteral(resourceName: "error_icon")
    
    func configure () {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureView()
        
        addSubview(label)
        addSubview(imageView)
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8.0).isActive = true
        
        heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 64).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func configureView() {
        backgroundColor = .clear
        alpha = 0.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: FontSize.inputDesc.rawValue, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = icon
    }
    
    func show(mode: AlertMode, message: String) {
        if label.text != message { hidden() }
        
        self.label.text = message
        updateStyle(mode: mode)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    func hidden() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        }
    }
    
    private func updateStyle(mode: AlertMode) {
        let color: UIColor
        switch mode {
        case .warning:
            color = .orange
        case .error:
            color = .red
        }
        label.textColor = color
        imageView.image = icon.withTintColor(color)
    }
}

public enum AlertMode {
    case warning
    case error
}

public struct AlertModel {
    let message: String
    let mode: AlertMode
}
