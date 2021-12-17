//
//  ViewController.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 6/11/21.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {

    // MARK: - IBOutlet connections
    @IBOutlet weak var tableViewContainerView: UIView!
    @IBOutlet weak var informationTableView: UITableView!
    @IBOutlet weak var navigationBarContainerView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var globalCasesTitleLabel: UILabel!
    @IBOutlet weak var globalCasesValueLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!

    // The view model for this view controller.
    var viewModel = DashboardViewModel()

    // The loading screen view controller reference.
    weak var loadingScreenViewController: LoadingViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func bindViewModel() {
        viewModel.shouldBindNecessaryData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadingScreenViewController?.dismissLoadingScreen()
                self.populateUIWithData()
            }
        }
        viewModel.getNecessaryInitialData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show loading indicator.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let loadingScreenVC = LoadingViewController()
            loadingScreenVC.modalTransitionStyle = .crossDissolve
            loadingScreenVC.modalPresentationStyle = .overFullScreen
            self.loadingScreenViewController = loadingScreenVC
            self.present(loadingScreenVC, animated: true, completion: nil)

            // Bind view model.
            self.bindViewModel()
        }
    }

    private func setupUI() {
        self.view.backgroundColor = Color.mainBackgroundColor
        globalCasesTitleLabel.text = "Cases"
        globalCasesTitleLabel.textColor = Color.purpleTextColor
        globalCasesValueLabel.textColor = Color.purpleTextColor

        navigationBarContainerView.backgroundColor = Color.mainBackgroundColor
        navigationBarView.backgroundColor = Color.mainBackgroundColor
        tableViewContainerView.backgroundColor = Color.mainBackgroundColor

        informationTableView.delegate = self
        informationTableView.dataSource = self
        informationTableView.separatorStyle = .none
        informationTableView.backgroundColor = Color.mainBackgroundColor
        informationTableView.register(UINib(nibName: InformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InformationTableViewCell.identifier)
        informationTableView.register(UINib(nibName: GeneralInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GeneralInfoTableViewCell.identifier)

        countryFlagImageView.isUserInteractionEnabled = true
        countryFlagImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCountryFlag)))
    }

    private func populateUIWithData() {
        self.globalCasesValueLabel.text = "\(viewModel.cases ?? 0)"
        if let url = viewModel.currentCountryFlagUrl {
            self.countryFlagImageView.sd_setImage(with: url, completed: nil)
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.informationTableView.reloadData()
        }
    }

    @objc private func didTapCountryFlag() {
        print("tapped")
        let storyboard = UIStoryboard(name: StoryboardName.main, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: CountrySelectionViewController.identifier) as? CountrySelectionViewController {
            viewController.modalPresentationStyle = .overFullScreen
            viewController.countryNames = viewModel.getAllCountryNames()
            viewController.countryIconUrls = viewModel.getAllCountryFlagUrls()
            viewController.didChooseCountry = { [weak self] (chosenCountry) in
                guard let self = self else { return }
                self.viewModel.generateInformationToDisplay(for: chosenCountry)
            }

            self.present(viewController, animated: false, completion: nil)
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.generalInformationKeys.count + 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralInfoTableViewCell.identifier, for: indexPath) as! GeneralInfoTableViewCell
            let key = viewModel.generalInformationKeys[indexPath.row - 1]
            let value = viewModel.generalInformationValues[indexPath.row - 1]
            cell.configureCell(keyString: key, valueString: value)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as! InformationTableViewCell
        let data = viewModel.getFirstDataSet(chartType: .pieChart)
        let dataPerMillion = viewModel.getSecondDataSet(chartType: .barChart)
        let todayData = viewModel.getThirdDataSet(chartType: .horizontalBarChart)
        let dataSet = data.0
        let dataSetPerMillion = dataPerMillion.0
        let todayDataSet = todayData.0

        let dataSets: [ChartDataSet?] = [dataSet, dataSetPerMillion, todayDataSet]
        let labels = [data.1, dataPerMillion.1, todayData.1]
        let mainDisplayParameterKeys = ["Covid data", "Covid data (numbers/million)", "Covid data (today)"]
        
        cell.configureCell(dataSets: dataSets, labels: labels, mainDisplayParameterKeys: mainDisplayParameterKeys, chartTypes: [.pieChart, .barChart, .horizontalBarChart], cellHeight: tableView.bounds.height)
        return cell
    }
}

