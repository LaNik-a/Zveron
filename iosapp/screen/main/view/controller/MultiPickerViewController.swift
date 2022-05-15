//
//  MultiPickerViewController.swift
//  iosapp
//
//  Created by alexander on 07.05.2022.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol MultiPickerDelegate: AnyObject {
    func willFinish(parameter: LotParameter)
}

class MultiPickerViewController: UIViewController {
    var delegate: MultiPickerDelegate?
    private let disposeBag = DisposeBag()
    private var keyboardDismissTabGesture: UITapGestureRecognizer?
    private var parameter: LotParameter?
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return tableView
    }()

    private var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Применить фильтры", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()



    private var isBackButton: Bool?

    init(isBackButton: Bool, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.isBackButton = isBackButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        continueButton.applyGradient(.mainButton, .horizontal, Corner.mainButton.rawValue)
        updateCellsPresentation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        bindViews()
        registerForKeyboardNotifications()
        view.backgroundColor = Color.backgroundScreen.color
        navigationController?.navigationBar.backgroundColor = Color.backgroundScreen.color
    }

    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
        super.viewWillDisappear(animated)
    }

    private func configureScreen() {
        view.backgroundColor = Color.backgroundScreen.color
       // navigationController?.navigationBar.addSubview(statusBar)
        navigationItem.leftBarButtonItem =  isBackButton! ? backButton : closeButton
        let margin = view.layoutMarginsGuide
        view.addSubview(topic)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(continueButton)

        topic.topAnchor.constraint(equalTo: margin.topAnchor, constant: 24).isActive = true
        topic.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true

        continueButton.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        continueButton.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

        searchBar.topAnchor.constraint(equalTo: topic.bottomAnchor, constant: 16).isActive = true
        searchBar.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true

        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        tableView.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setup(parameter: LotParameter) {
        self.parameter = parameter
        topic.text = parameter.name
        self.filteredData = parameter.values!
        self.tableView.reloadData()
    }

    private func bindViews() {
        continueButton.rx.tap.bind(onNext: {_ in
            self.delegate?.willFinish(parameter: self.parameter!)
            self.leftItemButtonAction()
        }).disposed(by: disposeBag)
    }

    @objc
    private func leftItemButtonAction() {
        if isBackButton! {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    private func updateCellsPresentation() {
        // временный костыль
        let count =  filteredData.count > 13 ? 13 : filteredData.count
        for i in 0..<count {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath)!
            updateCellPresentation(cell: cell)
        }
    }
}

extension MultiPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = parameter!.values!
            tableView.reloadData()
        } else {
            filteredData = parameter!.values!.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
        }
    }
}

extension MultiPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        let text = filteredData[indexPath.item]
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let icon = #imageLiteral(resourceName: "checkbox")
        let color = #colorLiteral(red: 0.9086833596, green: 0.9089849591, blue: 0.9182793498, alpha: 1)
        cell.imageView?.image = icon.withTintColor(color)
        cell.textLabel?.text = text.capitalized
        updateCellPresentation(cell: cell)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        guard let text = cell.textLabel?.text?.lowercased() else { return }

        if parameter!.choosenValues!.contains(text) {
            parameter?.choosenValues?.removeAll(where: { $0 == text })
        } else {
            parameter?.choosenValues?.append(text)
        }
        updateCellPresentation(cell: cell)
    }

    private func updateCellPresentation(cell: UITableViewCell) {
        guard let text = cell.textLabel?.text?.lowercased() else { return }
        cell.imageView?.removeGradientLayer()
        if parameter!.choosenValues!.contains(text) {
            cell.imageView?.applyGradient(.mainButton, .horizontal, 6.0)
        }
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

// блок с обработкой клавиатуры
extension MultiPickerViewController {

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if keyboardDismissTabGesture == nil {
            keyboardDismissTabGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            keyboardDismissTabGesture?.cancelsTouchesInView = false
            view.addGestureRecognizer(keyboardDismissTabGesture!)
        }

        let userInfo = notification.userInfo
        guard let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        UIView.animate(withDuration: 0.5) {
            self.continueButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 16)
        }
    }

    @objc private func keyboardWillHide() {
        if keyboardDismissTabGesture != nil {
            view.removeGestureRecognizer(keyboardDismissTabGesture!)
            keyboardDismissTabGesture = nil
        }

        UIView.animate(withDuration: 0.5) {
            self.continueButton.transform = .identity
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
