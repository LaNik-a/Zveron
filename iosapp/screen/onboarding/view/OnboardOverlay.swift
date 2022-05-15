//
//  SwiftyOnboardOverlay.swift
//  iosapp
//
//  Created by Никита Ткаченко on 14.04.2022.
//

import Foundation
import UIKit
public class OnboardOverlay: UIView, UIScrollViewDelegate {
    public var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()
    
    public var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    public var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пропустить", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Позволяет делать скролл
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    public func page(count: Int) {
        pageControl.numberOfPages = count
    }
    
    public func currentPage(index: Int) {
        pageControl.currentPage = index
    }
    
    public func setUp() {
        self.addSubview(pageControl)
        
        let margin = self.layoutMarginsGuide
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.topAnchor.constraint(equalTo: margin.topAnchor, constant: 28).isActive = true
        pageControl.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 100).isActive = true
        pageControl.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -100).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -80).isActive = true
        continueButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 16).isActive = true
        continueButton.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -16).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        self.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -40).isActive = true
        skipButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 30).isActive = true
        skipButton.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -30).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        continueButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageControl.currentPageIndicatorTintColor = GradientColorForElements.mainButton.secondColor
    }
    
}
