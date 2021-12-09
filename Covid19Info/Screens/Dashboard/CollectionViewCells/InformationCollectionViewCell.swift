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
    case horizontalBarChart
}

class InformationCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: InformationCollectionViewCell.self)

    // MARK: - IBOutlet connections.
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainDisplayParameterLabel: UILabel!
    @IBOutlet weak var mainDisplayParameterContainerView: UIView!

    // Flag to only set chart if not set.
    private var hasDisplayedChart = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setupUI() {
        chartContainerView.layer.cornerRadius = 20
        mainDisplayParameterLabel.numberOfLines = 0
        mainDisplayParameterContainerView.layer.cornerRadius = 10
    }

    func configureCell(dataSet: ChartDataSet?, labels: [String]?, mainParameterKeyToDisplay: String, mainParameterValueToDisplay: String, chartType: ChartType) {
        mainDisplayParameterLabel.text = "\(mainParameterValueToDisplay) \(mainParameterKeyToDisplay)"
        switch chartType {
        case .barChart:
            if let dataSet = dataSet as? BarChartDataSet {
                let barChartView = ChartGenerator.generateBarChart(dataSet: dataSet, labels: labels)
                addChartToCell(chartView: barChartView)
            }
        case .pieChart:
            if let dataSet = dataSet as? PieChartDataSet {
                let pieChartView = ChartGenerator.generatePieChart(dataSet: dataSet, labels: labels)
                addChartToCell(chartView: pieChartView)
            }
        case .lineChart:
            if let dataSet = dataSet as? LineChartDataSet {
                let lineGraphView = ChartGenerator.generateLineGraph(dataSet: dataSet, labels: labels)
                addChartToCell(chartView: lineGraphView)
            }
        case .horizontalBarChart:
            if let dataSet = dataSet as? BarChartDataSet {
                let horizontalBarChartView = ChartGenerator.generateHorizontalBarChart(dataSet: dataSet, labels: labels)
                addChartToCell(chartView: horizontalBarChartView)
            }
        }
    }

    private func addChartToCell(chartView: UIView) {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.addSubview(chartView)
        NSLayoutConstraint.activate([chartView.leftAnchor.constraint(equalTo: chartContainerView.leftAnchor, constant: 16), chartView.rightAnchor.constraint(equalTo: chartContainerView.rightAnchor, constant: -16), chartView.topAnchor.constraint(equalTo: mainDisplayParameterLabel.bottomAnchor, constant: 8), chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -16)])
    }

}
