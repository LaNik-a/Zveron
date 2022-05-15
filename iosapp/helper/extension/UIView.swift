//
//  Utils.swift
//  iosapp
//
//  Created by alexander on 04.03.2022.
//

import UIKit

extension UIView {
    func applyGradient(
        _ element: GradientColorForElements,
        _ orientation: GradientOrientation,
        _ cornerRadius: CGFloat
    ) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        let colors = element.colors
        gradient.colors = [colors.firstColor, colors.secondColor].map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        gradient.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    // Градиент для границы кнопки с закруглением
    func applyGradientForBorder(
        _ element: GradientColorForElements,
        _ orientation: GradientOrientation,
        _ borderWidth: CGFloat,
        _ cornerRadius: CGFloat)
    {
        guard self.layer.sublayers!.filter { $0 is CAGradientLayer }.isEmpty else { return }
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: self.frame.size)
        let colors = element.colors
        gradient.colors = [colors.firstColor, colors.secondColor].map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        let shape = CAShapeLayer()
        shape.lineWidth = borderWidth
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
    }
    
    // Градиент для границы кнопки
    func applyGradientForBorder(
        _ element: GradientColorForElements,
        _ orientation: GradientOrientation,
        _ borderWidth: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: self.frame.size)
        let colors = element.colors
        gradient.colors = [colors.firstColor, colors.secondColor].map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        let shape = CAShapeLayer()
        shape.lineWidth = borderWidth
        shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
    }

    func removeGradientLayer(layerIndex index: Int) {
        guard let sublayers = self.layer.sublayers else { return }
        if sublayers.count > index {
            self.layer.sublayers!.remove(at: index)
        }
    }

    func removeGradientLayer() {
        guard let index = self.layer.sublayers?.firstIndex(where: { $0 is CAGradientLayer}) else {
            return
        }
        self.layer.sublayers!.remove(at: index)
    }
}
