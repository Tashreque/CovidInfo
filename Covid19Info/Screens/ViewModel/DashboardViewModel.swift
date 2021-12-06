//
//  DashboardViewModel.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 9/11/21.
//

import Foundation
import Charts

typealias CovidInformation = (ChartDataSet?, labels: [String]?)

class DashboardViewModel {
    /// The covid 19 global data.
    var globalSummary: Summary?

    /// All country based data.
    var dataForAllCountries = [CountryWiseInfo]()

    /// The default chart types to display.
    var defaultDisplayChartTypes: [ChartType] = [.barChart, .pieChart, .horizontalBarChart, .barChart]

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
                        self.shouldBindNecessaryData?()
                    }
                }
            }
        }
    }

    // Generate bar chart data sets.
    func getCasesDataSet(chartType: ChartType) -> CovidInformation {
        if let todayCases = globalSummary?.todayCases, let criticalCases = globalSummary?.critical, let casesPerMillion = globalSummary?.casesPerOneMillion, let activeCasesPerMillion = globalSummary?.activePerOneMillion, let criticalPerMillion = globalSummary?.criticalPerOneMillion {
            let entries = [Double(todayCases), Double(criticalCases), Double(casesPerMillion), Double(activeCasesPerMillion), Double(criticalPerMillion)]
            let labels = ["Cases today", "Critical cases", "Cases per million", "Active cases per million", "Critical per million"]
            switch chartType {
            case .barChart:
                return (generateBarDataSet(entries: entries), labels)
            case .pieChart:
                return (generatePieDataSet(entries: entries, labels: labels), labels)
            case .lineChart:
                return (generateLineDataSet(entries: entries), labels)
            case .horizontalBarChart:
                return (generateBarDataSet(entries: entries), labels)
            }
        }
        return (nil, nil)
    }

    // Generate bar chart data sets.
    func getDeathsDataSet(chartType: ChartType) -> CovidInformation {
        if let todayDeaths = globalSummary?.todayDeaths, let deathsPerMillion = globalSummary?.deathsPerOneMillion {
            let entries = [Double(todayDeaths), Double(deathsPerMillion)]
            let labels = ["Deaths today", "Deaths per million"]
            switch chartType {
            case .barChart:
                return (generateBarDataSet(entries: entries), labels)
            case .pieChart:
                return (generatePieDataSet(entries: entries, labels: labels), labels)
            case .lineChart:
                return (generateLineDataSet(entries: entries), labels)
            case .horizontalBarChart:
                return (generateBarDataSet(entries: entries), labels)
            }
        }
        return (nil, nil)
    }

    func getRecoveryDataSet(chartType: ChartType) -> CovidInformation {
        if let todayRecoveries = globalSummary?.todayRecovered, let recoveriesPerMillion = globalSummary?.recoveredPerOneMillion {
            let entries = [Double(todayRecoveries), Double(recoveriesPerMillion)]
            let labels = ["Recovered today", "Recoveries per million"]
            switch chartType {
            case .barChart:
                return (generateBarDataSet(entries: entries), labels)
            case .pieChart:
                return (generatePieDataSet(entries: entries, labels: labels), labels)
            case .lineChart:
                return (generateLineDataSet(entries: entries), labels)
            case .horizontalBarChart:
                return (generateBarDataSet(entries: entries), labels)
            }
        }
        return (nil, nil)
    }

    func getTestsDataSset(chartType: ChartType) -> CovidInformation {
        if let testsPerMillion = globalSummary?.testsPerOneMillion {
            let entries = [Double(testsPerMillion)]
            let labels = ["Tests per million"]
            switch chartType {
            case .barChart:
                return (generateBarDataSet(entries: entries), labels)
            case .pieChart:
                return (generatePieDataSet(entries: entries, labels: labels), labels)
            case .lineChart:
                return (generateLineDataSet(entries: entries), labels)
            case .horizontalBarChart:
                return (generateBarDataSet(entries: entries), labels)
            }
        }
        return (nil, nil)
    }


    // MARK: - Private functions.

    private func generateBarDataSet(entries: [Double]) -> BarChartDataSet? {
        var dataEntries = [BarChartDataEntry]()
        for (i, entry) in entries.enumerated() {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: entry))
        }
        let dataSet = BarChartDataSet(entries: dataEntries)
        return dataSet
    }

    private func generatePieDataSet(entries: [Double], labels: [String]) -> PieChartDataSet? {
        var dataEntries = [PieChartDataEntry]()
        for (i, entry) in entries.enumerated() {
            dataEntries.append(PieChartDataEntry(value: entry, label: labels[i]))
        }
        let dataSet = PieChartDataSet(entries: dataEntries)
        return dataSet
    }

    private func generateLineDataSet(entries: [Double]) -> LineChartDataSet? {
        var dataEntries = [ChartDataEntry]()
        for (i, entry) in entries.enumerated() {
            dataEntries.append(ChartDataEntry(x: Double(i), y: entry))
        }
        let dataSet = LineChartDataSet(entries: dataEntries)
        return dataSet
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
