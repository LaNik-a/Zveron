//
//  AllSubCategoryViewController.swift
//  iosapp
//
//  Created by alexander on 30.03.2022.
//

import UIKit

class AllSubCategoryViewController: UIViewController {
    static func storyboardInstance() -> AllSubCategoryViewController? {
           let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? AllSubCategoryViewController
        return vc
       }
    
    
    weak var delegate: AllSubCategoryViewControllerDelegate?
    
    @IBOutlet weak var tableViewSubCategory: UITableView!
    
    weak var parentController: SubCategoryViewController?
    
    let cellReuseIdentifier = "subCategoryCell"
    
    let subCategories:[SubCategory] = [
        SubCategory(title: "Собаки", image: #imageLiteral(resourceName: "dog_image")),
        SubCategory(title: "Кошки", image: #imageLiteral(resourceName: "cat_image")),
        SubCategory(title: "Рыби", image: #imageLiteral(resourceName: "fish_image")),
        SubCategory(title: "Птицы", image: #imageLiteral(resourceName: "bird_image")),
        SubCategory(title: "Грызуны", image: #imageLiteral(resourceName: "bird_image")),
        SubCategory(title: "Рептилии", image: #imageLiteral(resourceName: "bird_image")),
        SubCategory(title: "Другое", image: #imageLiteral(resourceName: "bird_image")),
        SubCategory(title: "Другое", image: #imageLiteral(resourceName: "bird_image")),
        SubCategory(title: "Другое", image: #imageLiteral(resourceName: "bird_image")),

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSubCategory.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableViewSubCategory.tableFooterView = UIView()
        tableViewSubCategory.delaysContentTouches = false
        // Do any additional setup after loading the view.
    }
    

    
}


extension AllSubCategoryViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return subCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else{
            fatalError("Wrong cell")

        }
        cell.backgroundColor = .clear
        cell.textLabel?.text = subCategories[indexPath.item].title
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 18.0)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 8
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        let subCategoryIdentifier = subCategories[indexPath.item].title
        parentController?.goToDetailSubCategoryScreen(subCategoryIdentifier, animated: false)
        delegate?.didSelectCategory(subCategoryIdentifier)
        dismiss(animated: true, completion: nil)
        }
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
        UIView.animate(withDuration: 0.2) {
        cell.plainView.alpha = 0.4
        }}
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
        UIView.animate(withDuration: 0.2) {
        cell.plainView.alpha = 1.0
        }}
    }
    
    
}


protocol AllSubCategoryViewControllerDelegate: AnyObject{
    
    func didSelectCategory(_ category:String)
    
}
