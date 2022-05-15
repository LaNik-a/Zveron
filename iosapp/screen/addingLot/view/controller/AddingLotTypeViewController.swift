//
//  LotTableViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 07.05.2022.
//

import UIKit
import RemoteDataService
import RxSwift
import RxRelay

class AddingLotTypeViewController: UIViewController {
    
    var lot: Lot = Lot()
    var parameters: [LotParameter] = []
    
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.separatorStyle  = .none
        table.backgroundColor = Color.backgroundScreen.color
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        return table
    }()
    
    lazy var titleTable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: FontSize.titleAddingLot.rawValue)
        label.textColor = .black
        label.sizeToFit()
        label.text = "Вид объявления"
        return label
    }()
    let navBtn = NavigationButton.back.button
    
    private var data: [TableInfo] = []
    private let viewModel = ViewModelFactory.get(AddingLotTypeViewModel.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViews()
    }
    
    func setUp() {
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Создание объявления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        
        self.view.addSubview(titleTable)
        titleTable.translatesAutoresizingMaskIntoConstraints = false
        titleTable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        titleTable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        titleTable.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.titleTable.bottomAnchor, constant: 15).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func bindViews() {
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}

extension AddingLotTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataRes: TableInfo
        dataRes = data[indexPath.row]
        let isAnimal: Bool = data.count > 1
        var categoryId: Int
        if isAnimal {
            lot.id_lot_form = dataRes.id
            categoryId = 1
        } else {
            lot.id_lot_form = dataRes.id
            categoryId = 2
        }
        if lot.id_lot_form == 1 {
            let vc =  CategoryTypeNestedViewController()
            let categoryRepository = CategoryRepository()
            categoryRepository.getSubCategories(categoryId: categoryId) { res in
                guard let response = res as? SuccessResponse<FailableCodableArray<Category>> else { return }
                // нужно сохранить id категории чтобы дальше работать с ним
                var categories = response.data.elements
                // а зачем отдавать в рандомном порядке???????
                categories = categories.sorted(by: { $0.id < $1.id })
                var tableInfo: [TableInfo] = categories.map { TableInfo( title: $0.name, subtitle: nil, id: $0.id)}
                vc.setUpData(data: tableInfo, lot: self.lot, parameters: self.parameters)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = Color.backgroundScreen.color
        var dataRes: TableInfo
        dataRes = data[indexPath.row]
        cell.textLabel?.text = dataRes.title
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.text = dataRes.subtitle
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView( _ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 0.5
        }
    }
    
    func tableView( _ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 1.0
        }
    }
}

extension AddingLotTypeViewController: SetDataProtocol {
    public func setUpData(data: [TableInfo], lot: Lot, parameters: [LotParameter]) {
        self.data = data
        self.lot = lot
        self.parameters = parameters
    }
}
