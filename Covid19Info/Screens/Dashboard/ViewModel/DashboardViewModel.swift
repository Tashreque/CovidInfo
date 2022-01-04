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

    // Historical data.
    private var historicalInfo: HistoricalInfo?

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

    /// Country flag URL.
    var currentCountryFlagUrl: URL? = URL(string: ConstantUrls.globeIconUrl)

    /// The selected country name.
    var selectedCountryName = "Global"

    /// This function must be initially called in order to bind this view model with its corresponding view controller.
    func getNecessaryInitialData() {
        // Get historical information.
        getHistoricalInfo { [weak self] (historicalInfo, errorMessage) in
            guard let self = self else { return }
            guard errorMessage == nil else {
                self.shouldDisplayErrorMessage?(errorMessage!)
                return
            }

            if let historicalInfo = historicalInfo {
                self.historicalInfo = historicalInfo

                // Get worldwide summary.
                self.getCovidSummary { (summary, errorMessage) in
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
        selectedCountryName = country
    }

    func getHistoricalDataSet() -> [LineChartDataSet?] {
        var caseDates = [Date]()
        var deathDates = [Date]()
        var recoveredDates = [Date]()

        if let casesDict = historicalInfo?.cases, let deathDict = historicalInfo?.deaths, let recoveredDict = historicalInfo?.recovered {
            let dateFormat = "m/d/yy"
            for each in casesDict {
                caseDates.append(each.key.getDate(stringFormat: dateFormat))
            }
            for each in deathDict {
                deathDates.append(each.key.getDate(stringFormat: dateFormat))
            }
            for each in recoveredDict {
                recoveredDates.append(each.key.getDate(stringFormat: dateFormat))
            }
            caseDates.sort()
            deathDates.sort()
            recoveredDates.sort()

            let caseDateStrings = caseDates.map({ $0.getDateString(format: dateFormat) })
            let deathDateStrings = deathDates.map({ $0.getDateString(format: dateFormat) })
            let recoveredDateStrings = recoveredDates.map({ $0.getDateString(format: dateFormat) })

            let caseEntries = caseDateStrings.map({ Double(casesDict[$0] ?? 0) })
            let deathEntries = deathDateStrings.map({ Double(deathDict[$0] ?? 0) })
            let recoveredEntries = recoveredDateStrings.map({ Double(recoveredDict[$0] ?? 0) })

            let caseDataSet = generateLineDataSet(entries: caseEntries, color: .systemRed)
            let deathDataSet = generateLineDataSet(entries: deathEntries, color: .systemBlue)
            let recoveredDataSet = generateLineDataSet(entries: recoveredEntries, color: .systemGreen)

            return [caseDataSet, deathDataSet, recoveredDataSet]
        }
        return []
    }

    // Generate bar chart data sets.
    func getFirstDataSet(chartType: ChartType) -> CovidInformation {
        if let cases = cases, let criticalCases = criticalCases, let deaths = deaths, let recoveries = recoveries {
            let entries = [Double(cases), Double(criticalCases), Double(deaths), Double(recoveries)]
            let labels = ["Cases", "Critical Cases", "Deaths", "Recoveries"]
            switch chartType {
            case .barChart:
                return (generateBarDataSet(entries: entries), labels)
            case .pieChart:
                return (generatePieDataSet(entries: entries, labels: labels), labels)
            case .lineChart:
                return (generateLineDataSet(entries: entries, color: .black), labels)
            case .horizontalBarChart:
                return (generateBarDataSet(entries: entries), labels)
            }
        }
        return (nil, nil)
    }

    // Generate bar chart data sets.
    func getSecondDataSet(chartType: ChartType) -> CovidInformation {
        if let casesPerMillion = casesPerMillion, let deathsPerMillion = deathsPerMillion, let recoveriesPerMillion = recoveriesPerMillion {
            let entries = [Double(casesPerMillion), Double(deathsPerMillion), Double(recoveriesPerMillion)]
            let labels = ["Cases/Million", "Deaths/Million", "Recoveries/Million"]
            switch chartType {
            case .barChart:
                return (generateBarDataSet(entries: entries), labels)
            case .pieChart:
                return (generatePieDataSet(entries: entries, labels: labels), labels)
            case .lineChart:
                return (generateLineDataSet(entries: entries, color: .black), labels)
            case .horizontalBarChart:
                return (generateBarDataSet(entries: entries), labels)
            }
        }
        return (nil, nil)
    }

    func getThirdDataSet(chartType: ChartType) -> CovidInformation {
        if let todayCases = todayCases, let todayDeaths = todayDeaths, let todayRecoveries = todayRecoveries {
            let entries = [Double(todayCases), Double(todayDeaths), Double(todayRecoveries)]
            let labels = ["Cases today", "Deaths today", "Recoveries today"]
            switch chartType {
            case .barChart:
                return (generateBarDataSet(entries: entries), labels)
            case .pieChart:
                return (generatePieDataSet(entries: entries, labels: labels), labels)
            case .lineChart:
                return (generateLineDataSet(entries: entries, color: .black), labels)
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
        let testsValue = String(tests ?? 0)
        let testsPerMillionValue = String(testsPerMillion ?? 0)
        let affectedCountriesValue = String(affectedCountries ?? 0)
        let oneCasePerPeopleValue = String(oneCasePerPeople ?? 0)
        let oneDeathPerPeopleValue = String(oneDeathPerPeople ?? 0)
        let oneTestPerPeopleValue = String(oneTestPerPeople ?? 0)

        generalInformationValues = [populationValue, activeCasesValue, activeCasesPerMillionValue, testsValue, testsPerMillionValue, affectedCountriesValue, oneCasePerPeopleValue, oneDeathPerPeopleValue, oneTestPerPeopleValue]
        generalInformationKeys = ["Population", "Active cases", "Active cases per million", "Tests", "Tests per million", "Affected countries", "One case per people", "One death per people", "One test per people"]
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

    private func generateLineDataSet(entries: [Double], color: UIColor) -> LineChartDataSet? {
        var dataEntries = [ChartDataEntry]()
        for (i, entry) in entries.enumerated() {
            dataEntries.append(ChartDataEntry(x: Double(i), y: entry))
        }
        let dataSet = LineChartDataSet(entries: dataEntries)
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.colors = [color]

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

    // API call for historical covid info.
    private func getHistoricalInfo(completion: @escaping (HistoricalInfo?, String?) -> ()) {
        NetworkManager.shared.getRequest(endpoint: CovidInfoEndpoint.historicalCovidInformation) { (result: Result<HistoricalInfo, NetworkError>) in
            switch result {
            case .success(let historicalData):
                completion(historicalData, nil)
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
