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
        globalCasesTitleLabel.text = "Global cases"
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
    }

    private func populateUIWithData() {
        if let summary = viewModel.globalSummary {
            self.globalCasesValueLabel.text = "\(summary.cases ?? 0)"
        } else {
            globalCasesValueLabel.text = "--"
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.informationTableView.reloadData()
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
        let casesData = viewModel.getCasesDataSet(chartType: .barChart)
        let deathsData = viewModel.getDeathsDataSet(chartType: .pieChart)
        let recoveryData = viewModel.getRecoveryDataSet(chartType: .horizontalBarChart)
        let testsData = viewModel.getTestsDataSset(chartType: .barChart)
        let casesDataSet = casesData.0
        let deathsDataSet = deathsData.0
        let recoveryDataSet = recoveryData.0
        let testsDataSet = testsData.0

        let dataSets: [ChartDataSet?] = [casesDataSet, deathsDataSet, recoveryDataSet, testsDataSet]
        let labels = [casesData.1, deathsData.1, recoveryData.1, testsData.1]
        let mainDisplayParameterKeys = ["cases", "deaths", "recoveries", "tests"]
        let mainDisplayParameterValues = [String(viewModel.globalSummary?.cases ?? 0), String(viewModel.globalSummary?.deaths ?? 0), String(viewModel.globalSummary?.recovered ?? 0), String(viewModel.globalSummary?.tests ?? 0)]
        
        cell.configureCell(dataSets: dataSets, labels: labels, mainDisplayParameterKeys: mainDisplayParameterKeys, mainDisplayParameterValues: mainDisplayParameterValues, chartTypes: viewModel.defaultDisplayChartTypes, cellHeight: tableView.bounds.height)
        return cell
    }
}

