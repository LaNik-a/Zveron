//
//  MainScreenViewController.swift
//  iosapp
//
//  Created by alexander on 30.01.2022.
//

import UIKit
import DropDown
import BottomSheet
import SnapKit

class MainScreenViewController: UIViewController{

    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var changePresentStyleButton: UIBarButtonItem!
    @IBOutlet weak var adCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var buttonCategoryAnimal: UIButton!
    
    @IBOutlet weak var buttonCategoryProduct: UIButton!
    
    private var transitionDelegate: UIViewControllerTransitioningDelegate?

    let dropDownContent = DropDown()
    
    var dropDownMenu: UIBarButtonItem!
    
    private enum PresentationStyle: String, CaseIterable {
            case table
            case defaultGrid
            
            var buttonImage: UIImage {
                switch self {
                case .table: return  #imageLiteral(resourceName: "default_grid")
                case .defaultGrid: return #imageLiteral(resourceName: "present_style_row")
                }
            }
        }
    
    private var selectedStyle: PresentationStyle = .defaultGrid {
            didSet { updatePresentationStyle() }
    }
    
    
    private enum SortedType:String, CaseIterable {
        case popularity = "Популярные"
        case cheap = "Дешевые"
        case expensive = "Дорогие"
        case near = "Рядом с вами"
        case sellerRating = "С высоким рейтингом"
        
        
        
        
        static func parseType(_ name:String) -> SortedType {
            guard let type = SortedType.init(rawValue: name) else { return .popularity}
            return type
        }
        
        
    }
    
    private var selectedTypeSorting:SortedType = .popularity {
        didSet{
          updateDataSourceWithSorting()
        }
    }
    
    
    

    
     
    
    
    private var styleDelegates: [PresentationStyle: CollectionViewSelectableItemDelegate] = {
            let result: [PresentationStyle: CollectionViewSelectableItemDelegate] = [
                .table: TabledContentCollectionViewDelegate(),
                .defaultGrid: DefaultGriddedContentCollectionViewDelegate()
            ]
        
        
            result.values.forEach {
                
                // Listener for click on element
                $0.didSelectItem = { index in
                    
                    print("item selected at index: \(index.item)")
                    
                }
            }
        
            return result
        }()
    
        
    private func configureScreen(){
    //MARK: Кнопки категорий
        
        // Кнопка категория "Животные"
        buttonCategoryAnimal.setImage(#imageLiteral(resourceName: "animals_image"), for: .normal)
        buttonCategoryAnimal.setBackgroundImage(#imageLiteral(resourceName: "animals_background"), for: .normal)
        buttonCategoryAnimal.setTitle("Животные", for: .normal)
        buttonCategoryAnimal.layoutButton(style: .Top, imageTitleSpace: 10.0)
        
        // Кнопка категория "Товары для животных"
        buttonCategoryProduct.setImage(#imageLiteral(resourceName: "product_image"), for: .normal)
        buttonCategoryProduct.setBackgroundImage(#imageLiteral(resourceName: "product_background"), for: .normal)
        buttonCategoryProduct.setTitle("Товары", for: .normal)
        buttonCategoryProduct.layoutButton(style: .Top, imageTitleSpace: 10.0)
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureScreen()
        
        adCollectionView.register(AdvertCollectionViewCell.nib, forCellWithReuseIdentifier: AdvertCollectionViewCell.reuseID)
        adCollectionView.contentInset = .zero

        updatePresentationStyle()
        
        selectedTypeSorting = .popularity
        
      
        let images = #imageLiteral(resourceName: "dropArrow")
        dropDownMenu = UIBarButtonItem(title: selectedTypeSorting.rawValue, image: images, target: self, selector: #selector(MainScreenViewController.clickToDropDownMenu(_:)), reverse: true)
        
        toolBar.items?.append(dropDownMenu)
       // toolBar.tintColor = .de
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if (!RefreshTokenService.isStarted){
            let newVC = MainAuthViewController()
            let navigationController = BottomSheetNavigationController(rootViewController: newVC)
            transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
            navigationController.transitioningDelegate = transitionDelegate
            navigationController.modalPresentationStyle = .custom
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
   @objc private func rigthButtonClicked(_ sender:UIButton){
        print("clicked")
    }
    
    private func updatePresentationStyle() {
        adCollectionView.delegate = styleDelegates[selectedStyle]
        adCollectionView.performBatchUpdates({adCollectionView.reloadData()}, completion: nil)
        changePresentStyleButton.image = selectedStyle.buttonImage
    }
    
    private func updateDataSourceWithSorting(){
        print("new status \(selectedTypeSorting.rawValue)")
    }
    
    
    // MARK: Событие изменения представления объявлений
    @IBAction func changeTypeContentLayout(_ sender: Any) {
        let allCases = PresentationStyle.allCases
        guard let index = allCases.firstIndex(of: selectedStyle) else { return }
        let nextIndex = (index + 1) % allCases.count
        selectedStyle = allCases[nextIndex]
    }
    
    
    
    @IBAction func goToFilterScreen(_ sender: AnyObject) {
               if let filterViewController = SubCategoryViewController.storyboardInstance()  {
                navigationController?.pushViewController(filterViewController, animated: true)
               }
        //        if let filterViewController = AdvertFilterViewController.storyboardInstance()  {
        //            navigationController?.pushViewController(filterViewController, animated: true)
        //        }
        
    }
    
    
    
    @IBAction func clickToDropDownMenu(_ sender: UIButton) {
        
        dropDownContent.dataSource = SortedType.allCases.map{$0.rawValue}
        dropDownContent.cellNib = UINib(nibName: "SortingCell", bundle: nil)
        dropDownContent.customCellConfiguration = {[weak self] (index:Index,item:String,cell:DropDownCell) in
            guard let mySelf = self else {return}
            guard let myCell = cell as? SortingCell else {return}
            let image = #imageLiteral(resourceName: "selectedSortingType")
                
            if mySelf.selectedTypeSorting.rawValue.elementsEqual(item){
              myCell.logoImage.image = image
            } else {
                myCell.logoImage.image = nil
            }
            
        }
        
        
        dropDownContent.cornerRadius = 10
        dropDownContent.separatorColor = .black
        dropDownContent.backgroundColor = .systemGray6
        dropDownContent.direction = .bottom
        
        
        dropDownContent.anchorView = sender
        dropDownContent.bottomOffset = CGPoint(x: 0, y:Int((dropDownContent.anchorView?.plainView.bounds.height)!))
        dropDownContent.show()
        dropDownContent.selectionAction = {[weak self] (index:Int, item:String) in
            guard let selfView = self else {return}
            
            sender.setTitle(item + " ", for: .normal)
            
            //sender.sizeToFit()
            selfView.selectedTypeSorting = SortedType.parseType(item)
        }
    }
    
    
}




// Заполнение ячеек данными
extension MainScreenViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 10
     }
     
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertCollectionViewCell.reuseID,
                                                             for: indexPath) as? AdvertCollectionViewCell else {
             fatalError("Wrong cell")
         }

         return cell
     }
    
}



extension UIBarButtonItem {
    convenience init(title: String, image: UIImage, target: Any, selector: Selector, reverse: Bool) {
            let button = UIButton(type: .system)
            let imageSize = CGSize(width: 12, height: 9)
            button.setImage(image.scale(to: imageSize), for: .normal)
            let titleString = reverse ?  title + " " : " " + title
            button.setTitle(titleString, for: .normal)
                
            button.addTarget(target, action: selector, for: .touchUpInside)
            
            if reverse {
                button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        
           // button.sizeToFit()

            self.init(customView: button)
        }
}

extension UIImage {
    func scale(to size: CGSize) -> UIImage {
        if self.size != size {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            self.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        } else { return self }
    }
}


extension MainScreenViewController: BottomSheetModalDismissalHandler, BottomSheetPresentationControllerFactory {
    var canBeDismissed: Bool { true }
    
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }
    
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
        .init(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self
        )
    }
}

extension MainScreenViewController: UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
