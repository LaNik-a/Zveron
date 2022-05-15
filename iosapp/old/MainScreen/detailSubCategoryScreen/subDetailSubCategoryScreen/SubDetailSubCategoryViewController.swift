//
//  SubDetailSubCategoryViewController.swift
//  iosapp
//
//  Created by alexander on 08.04.2022.
//

import UIKit

class SubDetailSubCategoryViewController: UIViewController {
    static func storyboardInstance(_ identifier:String) -> SubDetailSubCategoryViewController? {
           let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? SubDetailSubCategoryViewController
        vc?.detailSubCategoryIdentifier = identifier
        return vc
       }
    
    private var detailSubCategoryIdentifier: String = ""
    private var subDetailSubCategories: [String] = []
    let cellReuseIdentifier = "subDetailSubCategoryCell"

    @IBOutlet weak var tableViewSubDetailSubCategory: UITableView!
    @IBOutlet public weak var buttonShowResult: UIButton!
    @IBOutlet public weak var label: UILabel!

  
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = detailSubCategoryIdentifier
        
        //load from backend
        subDetailSubCategories = ["Лабрадор", "Хаски", "Маламут", "Немецкая овчарка", "Мопс", "Чихуа хуйа", "Чао епта какао", "Питчер"
                                  , "Колли", "Дог", "Бульдог", "Писька", "Хрен", "хрен2", "хрен3", "хрен4", "хрен5","хрен6","хрен7"]
        
        tableViewSubDetailSubCategory.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableViewSubDetailSubCategory.tableFooterView = UIView()
        tableViewSubDetailSubCategory.delaysContentTouches = false

        buttonShowResult.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        buttonShowResult.layer.cornerRadius = Corner.mainButton.rawValue
    }
}

extension SubDetailSubCategoryViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subDetailSubCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else{
            fatalError("Wrong cell")

        }
        cell.imageView?.image = #imageLiteral(resourceName: "checkbox").withTintColor(.gray)
        cell.backgroundColor = .clear
        cell.textLabel?.text = subDetailSubCategories[indexPath.item]
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
        
        if let cell = tableView.cellForRow(at: indexPath){
       
        
        switch cell.isSelected {
        case false: cell.imageView?.image = #imageLiteral(resourceName: "checkbox").withTintColor(.gray)
        case true: cell.imageView?.image = #imageLiteral(resourceName: "checkbox").withTintColor(.blue)
        }
        }
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





