

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol SinglePickerDelegate: AnyObject {
    func willFinish(subCategory: Category)
}

class SinglePickerViewController: UIViewController {
    var delegate: SinglePickerDelegate?
    private let disposeBag = DisposeBag()
    private var subCategories: [Category] = []
    private var filteredData: [String] = []
    private let reuseID = "cell"

    private var navigationLeftItem: UIBarButtonItem?

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(leftItemButtonAction), for: .touchUpInside)
        let closeIcon = #imageLiteral(resourceName: "close_icon")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = .black
        return UIBarButtonItem(customView: closeButton)
    }()

    private lazy var backButton: UIBarButtonItem = {
        let backButton = UIButton(type: .system)
        backButton.addTarget(self, action: #selector(leftItemButtonAction), for: .touchUpInside)
        let closeIcon = #imageLiteral(resourceName: "back_icon")
        backButton.setImage(closeIcon, for: .normal)
        backButton.tintColor = .black
        return UIBarButtonItem(customView: backButton)
    }()

    private let topic: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.textColor = Color.title.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .minimal

        search.searchTextField.backgroundColor = #colorLiteral(red: 0.9656843543, green: 0.965782702, blue: 0.9688259959, alpha: 1)

        search.placeholder = "Поиск по параметру '\(topic.text!)'"
        search.searchTextField.font = .systemFont(ofSize: 14, weight: .regular)
        search.showsBookmarkButton = false
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseID)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var isBackButton: Bool?

    init(isBackButton: Bool, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.isBackButton = isBackButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        bindViews()
        view.backgroundColor = Color.backgroundScreen.color
        //navigationController?.navigationBar.backgroundColor = Color.backgroundScreen.color
    }

    private func configureScreen() {
     //   view.backgroundColor = Color.backgroundScreen.color
      //  navigationController?.navigationBar.addSubview(statusBar)
        navigationItem.leftBarButtonItem =  isBackButton! ? backButton : closeButton
        let margin = view.layoutMarginsGuide
        view.addSubview(topic)
        view.addSubview(searchBar)
        view.addSubview(tableView)

        topic.topAnchor.constraint(equalTo: margin.topAnchor, constant: 24).isActive = true
        topic.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true

        searchBar.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 16).isActive = true
        searchBar.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true

        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        tableView.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setup(topic: String, categories: [Category]) {
        self.subCategories = categories
        self.topic.text = topic
        self.filteredData = categories.map { $0.name }
        self.tableView.reloadData()
    }

    private func bindViews() {
        tableView.rx.itemSelected.bind {index in
            let idx = index.row
            let selectedSubCategory =
            self.subCategories.filter { $0.name == self.filteredData[idx] }.first!
            self.delegate?.willFinish(subCategory: selectedSubCategory)
            self.leftItemButtonAction()
        }.disposed(by: disposeBag)

//
//        continueButton.rx.tap.bind(onNext: {_ in
//            self.delegate?.didFinish(parameter: self.parameter!)
//            self.close()
//        }).disposed(by: disposeBag)
    }

    @objc
    private func leftItemButtonAction() {
        if isBackButton! {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension SinglePickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = subCategories.map { $0.name }
            tableView.reloadData()
        } else {
            filteredData = subCategories.map { $0.name }.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
        }
    }
}

extension SinglePickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        let text = filteredData[indexPath.item]
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.text = text.capitalized
        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 0.5
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.plainView.alpha = 1.0
        }
    }
}
