//
//  AddingLotViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 28.04.2022.
//

import UIKit
import RxSwift

class AddingLotViewController: UIViewController {
    @IBOutlet weak var typeLotLabel: UILabel!
    @IBOutlet weak var addingImageLabel: UILabel!
    @IBOutlet weak var typeAnimalBtn: UIButton!
    @IBOutlet weak var typeLotAnimalBtn: UIButton!
    
    @IBOutlet weak var nameLotLabel: UILabel!
    @IBOutlet weak var nameLotField: UITextField!
    @IBOutlet weak var exampleLotLabel: UILabel!
    @IBOutlet weak var alert: Alert!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    let buttonAddImage = UIButton()
    let corner = Corner.mainButton.rawValue
    private let viewModel = ViewModelFactory.get(AddingLotViewModel.self)
    
    private var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    let navBtn = NavigationButton.close.button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViews()
    }
    
    private func bindViews() {
        nameLotField.rx.text.changed.bind(to: viewModel.nameLot).disposed(by: disposeBag)
        
        // Обработка состояния кнопки продолжить
        viewModel.continueBtn.bind(onNext: { isEnabled in
            self.continueBtn.isEnabled = isEnabled
            UIView.animate(withDuration: 0.3) {
                self.continueBtn.alpha = isEnabled ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)
        
        // Обработка показа/скрытия предупреждения
        viewModel.alert.bind(onNext: { alertModel in
            guard let alertModel = alertModel else {
                self.alert.hidden()
                return
            }
            self.alert.show(mode: alertModel.mode, message: alertModel.message)
            self.exampleLotLabel.isHidden = true
        }).disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку выбора типа животного
        typeAnimalBtn.rx.tap.bind(onNext: { _ in
            self.viewModel.isAnimalType.accept(true)
        }).disposed(by: disposeBag)
        
        // Обработка нажатия на кнопку выбора типа товара для животного
        typeLotAnimalBtn.rx.tap.bind(onNext: { _ in
            self.viewModel.isAnimalType.accept(false)
        }).disposed(by: disposeBag)
        
        // настраиваем отображение кнопок (distinctUntilChanged - чтобы событие не вызывалось при сете
        // одинаковых значений - статья https://habr.com/ru/post/281292/)
        viewModel.isAnimalType.distinctUntilChanged().bind(onNext: { isAnimalType in
            if isAnimalType {
                self.typeAnimalBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
                self.typeAnimalBtn.tintColor = .white
                
                self.typeLotAnimalBtn.removeGradientLayer(layerIndex: 0)
                self.typeLotAnimalBtn.tintColor = .black
            } else {
                self.typeAnimalBtn.removeGradientLayer(layerIndex: 0)
                self.typeAnimalBtn.tintColor = .black
                
                self.typeLotAnimalBtn.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
                self.typeLotAnimalBtn.tintColor = .white
            }
        }).disposed(by: disposeBag)
        
        buttonAddImage.rx.tap.bind(onNext: {
            let provider = CameraProvider(delegate: self)
            do {
                if self.viewModel.photoLot.count < 5 {
                    let picker = try provider.getImagePicker(source: .photoLibrary)
                    self.present(picker, animated: true)
                }
            } catch {
                NSLog("Error: \(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)
        
        continueBtn.rx.tap.bind(onNext: {
            let vc =  AddingLotTypeViewController()
            var lot = Lot()
            var parameters: [LotParameter] = []
            var text = self.viewModel.nameLot.value
            text?.capitalizeFirstLetter()
            lot.title = text
            lot.photos = self.viewModel.photoLot
            var data: [TableInfo]
            if self.viewModel.isAnimalType.value {
                data = [TableInfo(title: "Продажа", subtitle: nil, id: 1), TableInfo(title: "На случку", subtitle: nil, id: 2), TableInfo(title: "В аренду", subtitle: nil, id: 3)]
            }
            else {
                data = [TableInfo(title: "Продажа", subtitle: nil, id: 4)]
            }
            
            // делать проверку по нажатию кнопки - если животное один хардкод если товары другой
            vc.setUpData(data: data, lot: lot, parameters: parameters)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        
        viewModel.successCreateLot.subscribe(onNext: { _ in
            // self.closeAddingLot()
        }).disposed(by: disposeBag)
        
        navBtn.rx.tap.bind(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    func addImageInStack(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor =  Color.imageBorder.color.cgColor
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        imageView.clipsToBounds = true
        stackView.addArrangedSubview(imageView)
    }
    
    public func setUp() {
        scrollView.backgroundColor = Color.backgroundScreen.color
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        typeLotLabel.text = "Тип объявления"
        typeLotLabel.font = .boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        
        typeLotAnimalBtn.setTitle("Товары для животных", for: .normal)
        typeLotAnimalBtn.contentHorizontalAlignment = .center
        typeLotAnimalBtn.tintColor = .black
        typeLotAnimalBtn.layer.cornerRadius = corner
        typeLotAnimalBtn.clipsToBounds = true
        typeLotAnimalBtn.applyGradientForBorder(.mainButton, .horizontal, 2, corner)
        
        typeAnimalBtn.setTitle("Животные", for: .normal)
        typeAnimalBtn.contentHorizontalAlignment = .center
        typeAnimalBtn.tintColor = .black
        typeAnimalBtn.layer.cornerRadius = corner
        typeAnimalBtn.clipsToBounds = true
        typeAnimalBtn.applyGradientForBorder(.mainButton, .horizontal, 2, corner)
        self.typeAnimalBtn.applyGradient(.mainButton, .horizontal, 10)
        
        addingImageLabel.text = "Добавьте фотографии"
        addingImageLabel.font = .boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        nameLotLabel.text = "Укажите название"
        nameLotLabel.font = .boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        exampleLotLabel.text = "Например: Кошка «Леля». 3 года"
        exampleLotLabel.font = .systemFont(ofSize: FontSize.tipLot.rawValue)
        exampleLotLabel.textColor = .gray
        continueBtn.setTitle("Далее", for: .normal)
        continueBtn.contentHorizontalAlignment = .center
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.layer.cornerRadius = corner
        continueBtn.clipsToBounds = true
        continueBtn.applyGradient(.mainButton, .horizontal, corner)
        continueBtn.alpha = 0.5
        continueBtn.isEnabled = false
        
        buttonAddImage.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        buttonAddImage.backgroundColor = .white
        buttonAddImage.setTitle("Добавьте\nфотографию", for: .normal)
        buttonAddImage.setTitleColor(.black, for: .normal)
        buttonAddImage.titleLabel?.numberOfLines = 0
        buttonAddImage.titleLabel?.textAlignment = .center
        buttonAddImage.titleLabel?.font = .systemFont(ofSize: 14)
        buttonAddImage.layer.cornerRadius = 8
        buttonAddImage.translatesAutoresizingMaskIntoConstraints = false
        buttonAddImage.widthAnchor.constraint(equalToConstant: 140).isActive = true
        let icon = UIImage(named: "plusGradient")!
        buttonAddImage.setImage(icon, for: .normal)
        buttonAddImage.imageView?.contentMode = .scaleAspectFit
        buttonAddImage.centerVertically()
        stackView.addArrangedSubview(buttonAddImage)
        alert.configure()
    }
    
}

extension AddingLotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (
            info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        )
        // здесь нужно будет добавить обработку незагруженной фотки
        guard let image = image else { return }
        var images = viewModel.imagesLot.value
        images.append(image)
        viewModel.imagesLot.accept(images)
        addImageInStack(image)
        self.viewModel.uploadImage()
        picker.dismiss(animated: true, completion: nil)
    }
}

