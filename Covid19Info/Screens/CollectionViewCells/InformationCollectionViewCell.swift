//
//  InformationCollectionViewCell.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 3/12/21.
//

import UIKit
import Charts

enum ChartType {
    case barChart
    case pieChart
    case lineChart
}

class InformationCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: InformationCollectionViewCell.self)

    // MARK: - IBOutlet connections.
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!

    // Flag to only set chart if not set.
    private var hasDisplayedChart = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setupUI() {
        chartContainerView.layer.cornerRadius = 20
    }

    func configureCell(dataSet: ChartDataSet?, chartType: ChartType) {
        if !hasDisplayedChart {
            switch chartType {
            case .barChart:
                if let dataSet = dataSet as? BarChartDataSet {
                    setupBarChart(dataSet: dataSet)
                }
            case .pieChart:
                if let dataSet = dataSet as? PieChartDataSet {
                    setupPieChart(dataSet: dataSet)
                }
            case .lineChart:
                print("")
            }
            hasDisplayedChart = true
        }
    }

    // Called to display a bar chart.
    private func setupBarChart(dataSet: BarChartDataSet) {
        let barChartView = BarChartView()

        // Set up cases data.
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont.systemFont(ofSize: 14, weight: .semibold)

        let xAxis = barChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .topInside
        xAxis.axisLineColor = Color.mainBackgroundColor
        xAxis.axisLineWidth = 2
        xAxis.granularity = 1

        let leftAxis = barChartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisLineColor = Color.mainBackgroundColor
        leftAxis.labelTextColor = .white
        leftAxis.axisLineWidth = 2

        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false

        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        barChartView.animate(xAxisDuration: 0.5)
        barChartView.animate(yAxisDuration: 0.5)
        let legend = barChartView.legend
        legend.textColor = .white
        legend.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        var legendEntries = [LegendEntry]()
        let xAxisLabels = ["Today", "Critical cases", "Active per 1 million", "Critical per 1 million"]
        for each in xAxisLabels {
            let entry = LegendEntry()
            entry.label = each
            entry.form = .default
            entry.formColor = .orange
            entry.formSize = 8
            legendEntries.append(entry)
        }
        barChartView.legend.setCustom(entries: legendEntries)

        // Add to cell.
        addChartToCell(chartView: barChartView)
    }

    // Called to display a pie chart.
    private func setupPieChart(dataSet: PieChartDataSet) {
        let pieChartView = PieChartView()

        // Set up cases data.
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont.systemFont(ofSize: 14, weight: .semibold)

        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.animate(xAxisDuration: 0.5)
        pieChartView.animate(yAxisDuration: 0.5)
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.legend.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        pieChartView.legend.textColor = .white

        // Add to cell.
        addChartToCell(chartView: pieChartView)
    }

    private func addChartToCell(chartView: UIView) {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.addSubview(chartView)
        NSLayoutConstraint.activate([chartView.leftAnchor.constraint(equalTo: chartContainerView.leftAnchor, constant: 8), chartView.rightAnchor.constraint(equalTo: chartContainerView.rightAnchor, constant: -8), chartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: 8), chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -8)])
    }

}
