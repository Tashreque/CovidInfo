//
//  CountrySelectionViewController.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 10/12/21.
//

import UIKit

class CountrySelectionViewController: UIViewController {

    // MARK: - IBOutlet connections.
    @IBOutlet weak var sideBarView: UIView!
    @IBOutlet weak var sideBarTableView: UITableView!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var sideBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideBarLeftConstraint: NSLayoutConstraint!

    /// The identifier for this view controller.
    static let identifier = String(describing: CountrySelectionViewController.self)

    /// This closure is called in order to pass the chosen country string back to the previous view controller.
    var didChooseCountry: ((String) -> ())?

    /// The list of country names which must be assigned prior to the presentation of this view controller.
    var countryNames = [String]()

    /// The list of icon URLs which must be assigned prior to the presentation of this view controller.
    var countryIconUrls = [String]()

    // The view model instance.
    private let viewModel = CountrySelectionViewModel()

    // Magic numbers.
    private var sideBarWidth: CGFloat {
        return self.view.bounds.width * 0.80
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupUI()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.shouldUpdateCountryList = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.sideBarTableView.reloadData()
            }
        }
        viewModel.setCountryList(countries: countryNames, flagUrlList: countryIconUrls)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if let view = touch.view, view != sideBarView, view != sideBarTableView {
                animateAndDismiss()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAndShowSideBar()
    }

    private func setupUI() {
        self.view.backgroundColor = .clear
        sideBarWidthConstraint.constant = sideBarWidth
        sideBarLeftConstraint.constant = -sideBarWidth

        sideBarTableView.backgroundColor = Color.mainChartBackgroundColor
        sideBarTableView.separatorStyle = .none
        sideBarTableView.delegate = self
        sideBarTableView.dataSource = self
        sideBarTableView.register(UINib(nibName: CountryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CountryTableViewCell.identifier)

        countrySearchBar.delegate = self
        countrySearchBar.textContentType = .countryName
        countrySearchBar.placeholder = "Country name"
        countrySearchBar.searchTextField.tintColor = Color.purpleTextColor
        countrySearchBar.searchTextField.textColor = Color.purpleTextColor
        countrySearchBar.searchTextField.leftView?.tintColor = Color.purpleTextColor
        countrySearchBar.backgroundImage = UIImage()
    }

    private func animateAndShowSideBar() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.sideBarLeftConstraint.constant += self.sideBarWidth
            self.view.backgroundColor = Color.mainBackgroundColor.withAlphaComponent(0.80)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func animateAndDismiss(chosenCountry: String? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            self.sideBarLeftConstraint.constant -= self.sideBarWidth
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        } completion: { isCompleted in
            if isCompleted {
                self.dismiss(animated: true) {
                    if let chosenCountry = chosenCountry {
                        self.didChooseCountry?(chosenCountry)
                    }
                }
            }
        }

    }

}

extension CountrySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as! CountryTableViewCell
        cell.configureCell(name: viewModel.countryList[indexPath.row], iconUrlString: viewModel.flagUrls[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryName = viewModel.countryList[indexPath.row]
        animateAndDismiss(chosenCountry: countryName)
    }
}

extension CountrySelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCountries(searchText: searchText)
    }
}
