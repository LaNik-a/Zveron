//
//  SwiftyOnboardPage.swift
//  iosapp
//
//  Created by Никита Ткаченко on 14.04.2022.
//

import Foundation
import UIKit

public class OnboardPage: UIView {
    
    public var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.title.rawValue)
        label.sizeToFit()
        return label
    }()
    
    public var subTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: FontSize.subtitle.rawValue)
        label.sizeToFit()
        return label
    }()
    
    public var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public func setUp() {
        self.addSubview(imageView)
        
        let margin = self.layoutMarginsGuide
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 60).isActive = true
        imageView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -60).isActive = true
        imageView.topAnchor.constraint(equalTo: margin.topAnchor, constant: 100).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 30).isActive = true
        title.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -30).isActive = true
        title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        self.addSubview(subTitle)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 30).isActive = true
        subTitle.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -30).isActive = true
        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
    }
}
