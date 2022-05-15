//
//  CategoryTypeNestedViewController.swift
//  iosapp
//
//  Created by Никита Ткаченко on 08.05.2022.
//

import UIKit
import RxSwift
import RemoteDataService
class CategoryTypeNestedViewController: UIViewController, UISearchBarDelegate {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.separatorStyle  = .none
        table.backgroundColor = Color.backgroundScreen.color
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = true
        return table
    }()
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        // чтобы взаимодействовать с отображаемым контентом для тапа по записям
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "Поиск по видам"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.delegate = self
        return s
    }()
    
    private var data: [TableInfo] = []
    private var filteredData: [TableInfo] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var lot: Lot = Lot()
    private var parameters: [LotParameter] = []
    private let viewModel = ViewModelFactory.get(CategoryTypeNestedViewModel.self)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        self.view.backgroundColor = Color.backgroundScreen.color
        navigationItem.title = "Виды животных"
        let navBtn = NavigationButton.back.button
        navBtn.rx.tap.bind(onNext: {
            self.navigationController?.popViewController(animated: true)
        })
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBtn)
        navigationItem.searchController = searchController
        
        self.view.addSubview(tableView)
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
}

extension CategoryTypeNestedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataRes: TableInfo
        if !isFiltering {
            dataRes = data[indexPath.row]
        } else {
            dataRes = filteredData[indexPath.row]
        }
        let lotRepository = LotRepository()
        lot.id_category = dataRes.id!
        lotRepository.getLotParameters(categoryId: dataRes.id!, callback: { res in
            guard let response = res as? SuccessResponse<FailableCodableArray<LotParameter>> else { return }
            
            var parameters:[LotParameter] = response.data.elements
            parameters = parameters.sorted(by: { $0.name < $1.name })
            // Здесь получили все параметры лота
            parameters = parameters.map { parameter in
                LotParameter(
                    id: parameter.id,
                    name: parameter.name,
                    type: parameter.type,
                    isRequired: parameter.isRequired,
                    values: parameter.values
                )
            }
            var tableInfo: [TableInfo] = []
            
            
            let lotParamBreed = parameters.filter({$0.name == "Порода"}).first
            guard let lotParamBreed = lotParamBreed as? LotParameter else { return }
            let breeds = lotParamBreed.values!
            for el in breeds {
                tableInfo.append(TableInfo(title: el, subtitle: nil, id: lotParamBreed.id))
            }
            let vc =  CategoryBreedsNestedViewController()
            vc.setUpData(data: tableInfo, lot: self.lot, parameters: parameters)
            self.navigationController?.pushViewController(vc, animated: true)
        })

        // Значит нет еще элементов уйти на другой контрллер
        print("Нет элементов")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = Color.backgroundScreen.color
        var dataRes: TableInfo
        
        if !isFiltering {
            dataRes = data[indexPath.row]
        } else {
            dataRes = filteredData[indexPath.row]
        }
        cell.textLabel?.text = dataRes.title
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.text = dataRes.subtitle
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
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

extension CategoryTypeNestedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredData = data.filter { row in
            return row.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}

extension CategoryTypeNestedViewController: SetDataProtocol {
    
    public func setUpData(data: [TableInfo], lot: Lot, parameters: [LotParameter]) {
        self.data = data
        self.lot = lot
        self.parameters = parameters
    }
}
