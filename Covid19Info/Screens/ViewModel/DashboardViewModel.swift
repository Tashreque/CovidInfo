//
//  DashboardViewModel.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 9/11/21.
//

import Foundation
import Charts

typealias CaseParametersForPieChart = (casesToday: Double, activeCases: Double, criticalCases: Double, activeCasesPerMillion: Double, criticalCasesPerMillion: Double)
typealias CaseParametersForBarChart = (cases: Double, casesToday: Double, casesPerMillion: Double, criticalCases: Double, criticalCasesPerMillion: Double, activeCases: Double, activeCasesPerMillion: Double)

class DashboardViewModel {
    /// The covid 19 global data.
    var globalSummary: Summary?

    /// All country based data.
    var dataForAllCountries = [CountryWiseInfo]()

    /// The summary data sets to display (bar).
    var summaryDataSets = [ChartDataSet?]()
    var summaryChartTypes = [ChartType]()

    /// The closure which is called in order to bind the view model with the view controller.
    var shouldBindNecessaryData: (() -> ())?

    /// The closure which is called in order to let the view controller know that an error message needs to be shown.
    var shouldDisplayErrorMessage: ((String) -> ())?

    init() {
        getNecessaryInitialData()
    }

    func getNecessaryInitialData() {
        getCovidSummary { [weak self] (summary, errorMessage) in
            guard let self = self else { return }
            guard errorMessage == nil else {
                self.shouldDisplayErrorMessage?(errorMessage!)
                return
            }
            if let summary = summary {
                self.globalSummary = summary
                self.getAllCountryWiseInformation { allCountryWiseInfo, errorMessage in
                    guard errorMessage == nil else {
                        self.shouldDisplayErrorMessage?(errorMessage!)
                        return
                    }
                    if let allCountryWiseInfo = allCountryWiseInfo {
                        self.dataForAllCountries = allCountryWiseInfo
                        self.getDataSetsToDisplay()
                        self.shouldBindNecessaryData?()
                    }
                }
            }
        }
    }

    func getDataSetsToDisplay() {
        let barDataSet = getBarDataSet()
        let pieDataSet = getPieDataSet()
        summaryDataSets = [barDataSet, pieDataSet, barDataSet, pieDataSet]
        summaryChartTypes = [.barChart, .pieChart, .barChart, .pieChart]
    }

    // Generate bar chart data sets.
    private func getBarDataSet() -> BarChartDataSet? {
        if let criticalCases = globalSummary?.critical, let todayCases = globalSummary?.todayCases, let criticalPerMillion = globalSummary?.criticalPerOneMillion, let activePerMillion = globalSummary?.activePerOneMillion {
            let entries = [BarChartDataEntry(x: 0, y: Double(todayCases)), BarChartDataEntry(x: 1, y: Double(criticalCases)), BarChartDataEntry(x: 2, y: Double(activePerMillion)), BarChartDataEntry(x: 3, y: Double(criticalPerMillion))]
            let dataSet = BarChartDataSet(entries: entries)
            return dataSet
        }
        return nil
    }

    // Generate pie data sets.
    private func getPieDataSet() -> PieChartDataSet? {
        if let criticalCases = globalSummary?.critical, let todayCases = globalSummary?.todayCases, let criticalPerMillion = globalSummary?.criticalPerOneMillion, let activePerMillion = globalSummary?.activePerOneMillion {
            let entries = [PieChartDataEntry(value: Double(todayCases), label: "Today cases"), PieChartDataEntry(value: Double(criticalCases), label: "Critical cases"), PieChartDataEntry(value: Double(activePerMillion), label: "Active per million"), PieChartDataEntry(value: Double(criticalPerMillion), label: "Critical per million")]
            let dataSet = PieChartDataSet(entries: entries)
            return dataSet
        }
        return nil
    }

    // API call for covid summary.
    private func getCovidSummary(completion: @escaping (Summary?, String?) -> ()) {
        NetworkManager.shared.getRequest(endpoint: CovidInfoEndpoint.globalInformation()) { (result: Result<Summary, NetworkError>) in
            switch result {
            case .success(let summary):
                completion(summary, nil)
            case .failure(let error):
                completion(nil, error.errorMessage)
            }
        }
    }

    // API call for summary for all countries.
    private func getAllCountryWiseInformation(completion: @escaping ([CountryWiseInfo]?, String?) -> ()) {
        NetworkManager.shared.getRequest(endpoint: CovidInfoEndpoint.informationOfAllCountries()) { (result: Result<[CountryWiseInfo], NetworkError>) in
            switch result {
            case .success(let dataForAllCountries):
                completion(dataForAllCountries, nil)
            case .failure(let error):
                completion(nil, error.errorMessage)
            }
        }
    }
}
