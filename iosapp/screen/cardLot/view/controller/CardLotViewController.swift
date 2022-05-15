//
//  CardLotViewController.swift
//  iosapp
//
//  Created by alexander on 30.04.2022.
//

import UIKit
import RemoteDataService
class CardLotViewController: UIViewController {
    
    
    private var imageLot: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .black
        imgView.layer.cornerRadius = 32
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private var titleLot: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Продам собаку породы Немецкая овчарка"
        return label
    }()
    
    private var addressLot: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Москва, Калининский район"
        return label
    }()
    
    private var titleDescription: UILabel = {
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
    
    private var descriptionLot: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = .black
        text.sizeToFit()
        text.text = "С другой стороны, перспективное планирование предопределяет высокую востребованность своевременного выполнения сверхзадачи" +
        ". Банальные, но неопровержимые выводы, а также стремящиеся вытеснить...С другой стороны, перспективное планирование предопределяет высокую востребованность" +
        " своевременного выполнения сверхзадачи. Банальные, но неопровержимые выводы, а также стремящиеся вытеснить"
        return text
    }()

    private var priceLot: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "20 000 $"
        return label
    }()
    
    private var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Написать", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    private var phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Позвонить", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lotRepository: LotRepository = LotRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getLot()
    }
    func setUp() {
        self.view.backgroundColor = Color.backgroundScreen.color
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        self.contentView.addSubview(imageLot)
        imageLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        imageLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        imageLot.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageLot.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        imageLot.heightAnchor.constraint(equalTo: self.imageLot.widthAnchor).isActive = true
        
        self.contentView.addSubview(titleLot)
        titleLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        titleLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        titleLot.topAnchor.constraint(equalTo: self.imageLot.bottomAnchor, constant: 24).isActive = true
        
        self.contentView.addSubview(addressLot)
        addressLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        addressLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        addressLot.topAnchor.constraint(equalTo: self.titleLot.bottomAnchor, constant: 8).isActive = true
        
        self.contentView.addSubview(titleDescription)
        titleDescription.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        titleDescription.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        titleDescription.topAnchor.constraint(equalTo: self.addressLot.bottomAnchor, constant: 8).isActive = true
        
        self.contentView.addSubview(descriptionLot)
        descriptionLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        descriptionLot.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        descriptionLot.topAnchor.constraint(equalTo: self.titleDescription.bottomAnchor, constant: 8).isActive = true
        
        self.contentView.addSubview(priceLot)
        priceLot.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        priceLot.topAnchor.constraint(equalTo: self.descriptionLot.bottomAnchor, constant: 20).isActive = true
        
        self.contentView.addSubview(phoneButton)
        phoneButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        phoneButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -35).isActive = true
        phoneButton.topAnchor.constraint(equalTo: self.priceLot.bottomAnchor, constant: 18).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: 47).isActive = true
        phoneButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
     
        self.contentView.addSubview(chatButton)
        chatButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        chatButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -35).isActive = true
        chatButton.topAnchor.constraint(equalTo: self.priceLot.bottomAnchor, constant: 18).isActive = true
        chatButton.heightAnchor.constraint(equalToConstant: 47).isActive = true
        chatButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
           
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chatButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        phoneButton.applyGradient(.phoneButton, .horizontal, Corner.mainButton.rawValue)
    }
    
    func getLot() {
        lotRepository.getLot(lotId: 50, callback: {res in
            guard let response = res as? SuccessResponse<CardLotPreview> else {
                print("ВСе плохл")
                return
            }
            print("Все хорошо")
        })
    }

}
