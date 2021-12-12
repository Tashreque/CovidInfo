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

    // All country based data.
    private var dataForAllCountries = [CountryWiseInfo]()

    // Global summary.
    private var globalSummary: Summary?

    /// The default chart types to display.
    var defaultDisplayChartTypes: [ChartType] = [.barChart, .pieChart, .horizontalBarChart, .barChart]

    /// General information keys. These are to be displayed in the cells following the charts.
    var generalInformationKeys = [String]()

    /// General information values. These are to be displayed in the cells following the charts.
    var generalInformationValues = [String]()

    /// The closure which is called in order to bind the view model with the view controller.
    var shouldBindNecessaryData: (() -> ())?

    /// The closure which is called in order to let the view controller know that an error message needs to be shown.
    var shouldDisplayErrorMessage: ((String) -> ())?

    // Cases parameters.
    var cases: Int?
    var todayCases: Int?
    var criticalCases: Int?
    var casesPerMillion: Int?
    var activeCasesPerMillion: Double?
    var criticalPerMillion: Double?
    var activeCases: Int?

    // Deaths parameters.
    var deaths: Int?
    var todayDeaths: Int?
    var deathsPerMillion: Double?

    // Recovery parameters.
    var recoveries: Int?
    var todayRecoveries: Int?
    var recoveriesPerMillion: Double?

    // Test parameters.
    var tests: Int?
    var testsPerMillion: Double?

    // Population.
    var totalPopulation: Int?

    // Effected countries.
    var affectedCountries: Int?

    // Other.
    var oneCasePerPeople: Int?
    var oneDeathPerPeople: Int?
    var oneTestPerPeople: Int?

    // Country flag URL.
    var currentCountryFlagUrl: URL? = URL(string: ConstantUrls.globeIconUrl)

    /// This function must be initially called in order to bind this view model with its corresponding view controller.
    func getNecessaryInitialData() {
        getCovidSummary { [weak self] (summary, errorMessage) in
            guard let self = self else { return }
            guard errorMessage == nil else {
                self.shouldDisplayErrorMessage?(errorMessage!)
                return
            }
            if let summary = summary {
                // Map data here.
                self.globalSummary = summary
                self.mapDataToViewModelParameters(summary: summary)

                self.getAllCountryWiseInformation { allCountryWiseInfo, errorMessage in
                    guard errorMessage == nil else {
                        self.shouldDisplayErrorMessage?(errorMessage!)
                        return
                    }
                    if let allCountryWiseInfo = allCountryWiseInfo {
                        self.dataForAllCountries = allCountryWiseInfo
                        self.generateGeneralInformation()
                        self.shouldBindNecessaryData?()
                    }
                }
            }
        }
    }

    func generateInformationToDisplay(for country: String) {
        if country == "Global" {
            if let summary = globalSummary {
                mapDataToViewModelParameters(summary: summary)
                currentCountryFlagUrl = URL(string: ConstantUrls.globeIconUrl)
                shouldBindNecessaryData?()
            }
        }
        if let countryInfo = dataForAllCountries.filter({ $0.country == country }).first {
            mapDataToViewModelParameters(countryWiseInfo: countryInfo)
            currentCountryFlagUrl = URL(string: countryInfo.countryInfo?.flag ?? "")
            shouldBindNecessaryData?()
        }
    }

    // Generate bar chart data sets.
    func getCasesDataSet(chartType: ChartType) -> CovidInformation {
        if let todayCases = todayCases, let criticalCases = criticalCases, let casesPerMillion = casesPerMillion, let activeCasesPerMillion = activeCasesPerMillion, let criticalPerMillion = criticalPerMillion {
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
        if let todayDeaths = todayDeaths, let deathsPerMillion = deathsPerMillion {
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
        if let todayRecoveries = todayRecoveries, let recoveriesPerMillion = recoveriesPerMillion {
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
        if let testsPerMillion = testsPerMillion {
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

    func getAllCountryNames() -> [String] {
        var allNames = ["Global"]
        let countryNames = dataForAllCountries.map({ $0.country ?? "" })
        allNames.append(contentsOf: countryNames)
        return allNames
    }

    func getAllCountryFlagUrls() -> [String] {
        var allUrls = [ConstantUrls.globeIconUrl]
        let urls = dataForAllCountries.map({ $0.countryInfo?.flag ?? "" })
        allUrls.append(contentsOf: urls)
        return allUrls
    }


    // MARK: - Private functions.

    private func generateGeneralInformation() {
        let populationValue = String(totalPopulation ?? 0)
        let activeCasesValue = String(activeCases ?? 0)
        let activeCasesPerMillionValue = String(activeCasesPerMillion ?? 0)
        let affectedCountriesValue = String(affectedCountries ?? 0)
        let oneCasePerPeopleValue = String(oneCasePerPeople ?? 0)
        let oneDeathPerPeopleValue = String(oneDeathPerPeople ?? 0)
        let oneTestPerPeopleValue = String(oneTestPerPeople ?? 0)

        generalInformationValues = [populationValue, activeCasesValue, activeCasesPerMillionValue, affectedCountriesValue, oneCasePerPeopleValue, oneDeathPerPeopleValue, oneTestPerPeopleValue]
        generalInformationKeys = ["Population", "Active cases", "Active cases per million", "Affected countries", "One case per people", "One death per people", "One test per people"]
    }

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

    private func mapDataToViewModelParameters(summary: Summary) {
        // Cases parameters.
        cases = summary.cases
        todayCases = summary.todayCases
        criticalCases = summary.critical
        casesPerMillion = summary.casesPerOneMillion
        activeCasesPerMillion = summary.activePerOneMillion
        criticalPerMillion = summary.criticalPerOneMillion
        activeCases = summary.active

        // Deaths parameters.
        deaths = summary.deaths
        todayDeaths = summary.todayDeaths
        deathsPerMillion = summary.deathsPerOneMillion

        // Recovery parameters.
        recoveries = summary.recovered
        todayRecoveries = summary.todayRecovered
        recoveriesPerMillion = summary.recoveredPerOneMillion

        // Test parameters.
        tests = summary.tests
        testsPerMillion = summary.testsPerOneMillion

        // Population.
        totalPopulation = summary.population

        // Effected countries.
        affectedCountries = summary.affectedCountries

        // Other.
        oneCasePerPeople = summary.oneCasePerPeople
        oneDeathPerPeople = summary.oneDeathPerPeople
        oneTestPerPeople = summary.oneTestPerPeople
    }

    private func mapDataToViewModelParameters(countryWiseInfo: CountryWiseInfo) {
        // Cases parameters.
        cases = countryWiseInfo.cases
        todayCases = countryWiseInfo.todayCases
        criticalCases = countryWiseInfo.critical
        casesPerMillion = countryWiseInfo.casesPerOneMillion
        activeCasesPerMillion = countryWiseInfo.activePerOneMillion
        criticalPerMillion = countryWiseInfo.criticalPerOneMillion
        activeCases = countryWiseInfo.active

        // Deaths parameters.
        deaths = countryWiseInfo.deaths
        todayDeaths = countryWiseInfo.todayDeaths
        deathsPerMillion = Double(countryWiseInfo.deathsPerOneMillion ?? 0)

        // Recovery parameters.
        recoveries = countryWiseInfo.recovered
        todayRecoveries = countryWiseInfo.todayRecovered
        recoveriesPerMillion = countryWiseInfo.recoveredPerOneMillion

        // Test parameters.
        tests = countryWiseInfo.tests
        testsPerMillion = Double(countryWiseInfo.testsPerOneMillion ?? 0)

        // Other.
        oneCasePerPeople = countryWiseInfo.oneCasePerPeople
        oneDeathPerPeople = countryWiseInfo.oneDeathPerPeople
        oneTestPerPeople = countryWiseInfo.oneTestPerPeople
    }
}
