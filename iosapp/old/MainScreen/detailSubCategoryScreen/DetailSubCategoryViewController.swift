//
//  DetailSubCategoryViewController.swift
//  iosapp
//
//  Created by alexander on 30.03.2022.
//

import UIKit

class DetailSubCategoryViewController: UIViewController {
    static func storyboardInstance(_ identifier:String) -> DetailSubCategoryViewController? {
           let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? DetailSubCategoryViewController
        vc?.subCategoryIdentifier = identifier
        return vc
       }
    
    @IBOutlet weak var labelTopic: UILabel!
    
    @IBOutlet weak var collectionViewDetailSubCategory: UICollectionView!

    var subCategoryIdentifier:String = ""
    
    var detailSubCategories:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //backend load detailSubCategories or one place for this info
        detailSubCategories = ["Порода", "Размер", "Длина хвоста"]
        
        
        labelTopic.text = subCategoryIdentifier
        
        
        collectionViewDetailSubCategory.register(DetailSubCategoryCollectionViewCell.nib, forCellWithReuseIdentifier: DetailSubCategoryCollectionViewCell.reuseID)
        collectionViewDetailSubCategory.contentInset = .zero
        collectionViewDetailSubCategory.dataSource = self as DetailSubCategoryCollectionViewDataSource
        collectionViewDetailSubCategory.delegate = self as DetailSubCategoryCollectionViewDataSource
        collectionViewDetailSubCategory.allowsSelection = true
        collectionViewDetailSubCategory.isUserInteractionEnabled = true
    }
    


}


//MARK: Расширение для коллекции под-категорий
extension DetailSubCategoryViewController : DetailSubCategoryCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailSubCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSubCategoryCollectionViewCell.reuseID,
                                                            for: indexPath) as? DetailSubCategoryCollectionViewCell else {
            fatalError("Wrong cell")
        }
        let source = detailSubCategories[indexPath.item]
        cell.update(title: source)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item selected at \(indexPath)")
        let detailSubCategoryIdentifier = detailSubCategories[indexPath.item]
        
        if let toVC = SubDetailSubCategoryViewController.storyboardInstance(detailSubCategoryIdentifier)  {
            navigationController?.present(toVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            UIView.animate(withDuration: 0.3){
                cell.plainView.alpha = 0.4
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            UIView.animate(withDuration: 0.3){
                cell.plainView.alpha = 1.0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSubCategoryCollectionViewCell.reuseID, for: indexPath) as? DetailSubCategoryCollectionViewCell else {
            fatalError("Wrong cell")
        }
        
        let source = detailSubCategories[indexPath.item]
        cell.update(title: source)
        
        let fittingSize = cell.labelDetailCategory.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: cell.labelDetailCategory.frame.height))


        return CGSize(width:fittingSize.width + 46, height:  fittingSize.height + 24)
    }
}
