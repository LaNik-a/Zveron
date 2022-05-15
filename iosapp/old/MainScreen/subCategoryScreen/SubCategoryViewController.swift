//
//  SubCategoryViewController.swift
//  iosapp
//
//  Created by alexander on 28.03.2022.
//

import UIKit

class SubCategoryViewController: UIViewController {
    static func storyboardInstance() -> SubCategoryViewController? {
           let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? SubCategoryViewController
        return vc
       }
    
    
    @IBOutlet weak var collectionViewSubCategory: UICollectionView!
    
    // Предыдщуий экран назначает данный датасет для под-категорий
    let subCategories:[SubCategory] = [
        SubCategory(title: "Собаки", image: #imageLiteral(resourceName: "dog_image")),
        SubCategory(title: "Кошки", image: #imageLiteral(resourceName: "cat_image")),
        SubCategory(title: "Рыби", image: #imageLiteral(resourceName: "fish_image")),
        SubCategory(title: "Птицы", image: #imageLiteral(resourceName: "bird_image"))
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSubCategory.contentInset = .zero
        collectionViewSubCategory.allowsSelection = true
        collectionViewSubCategory.isUserInteractionEnabled = true
    }
    
    
    

    @IBAction func goToAllSubCategoryScreen(_ sender: Any) {
        if let toVC = AllSubCategoryViewController.storyboardInstance()  {
            toVC.parentController = self
            navigationController?.present(toVC, animated: true, completion: nil)
        }
    }
    
    func goToDetailSubCategoryScreen(_ identifier:String, animated: Bool){
        if let toVC = DetailSubCategoryViewController.storyboardInstance(identifier)  {
            navigationController?.pushViewController(toVC, animated: animated)
        }
    }
}





    

