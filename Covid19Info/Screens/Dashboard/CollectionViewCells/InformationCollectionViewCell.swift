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

    // The chartView so that it can be tracked.
    var chartView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setupUI() {
        chartContainerView.layer.cornerRadius = 20
        mainDisplayParameterLabel.numberOfLines = 0
        mainDisplayParameterContainerView.backgroundColor = .black
        chartContainerView.clipsToBounds = true
    }

    func configureCell(dataSet: ChartDataSet?, labels: [String]?, mainParameterKeyToDisplay: String, chartType: ChartType) {
        // Remove any previous chart.
        chartView?.removeFromSuperview()

        // Display all parameters.
        mainDisplayParameterLabel.text = "\(mainParameterKeyToDisplay)"
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
            let lineGraphView = ChartGenerator.generateLineGraph(dataSet: LineChartDataSet(entries: [ChartDataEntry(x: 0, y: 1), ChartDataEntry(x: 1, y: 7), ChartDataEntry(x: 2, y: 3.75), ChartDataEntry(x: 3, y: 11.33), ChartDataEntry(x: 4, y: 6.50)]), labels: labels)
            addChartToCell(chartView: lineGraphView)
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
        self.chartView = chartView
    }

}
