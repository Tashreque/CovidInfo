//
//  ChartGenerator.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/12/21.
//

import Foundation
import Charts

struct ChartGenerator {

    /// Called to generate a bar chart for this project.
    static func generateBarChart(dataSet: BarChartDataSet, labels: [String]?) -> BarChartView {
        let barChartView = BarChartView()

        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont.systemFont(ofSize: 14, weight: .semibold)

        let xAxis = barChartView.xAxis
        xAxis.drawLabelsEnabled = false
        xAxis.labelPosition = .bothSided
        xAxis.axisLineColor = Color.mainBackgroundColor
        xAxis.gridColor = Color.mainBackgroundColor
        xAxis.axisLineWidth = 2
        xAxis.granularity = 1

        let leftAxis = barChartView.leftAxis
        leftAxis.axisLineColor = Color.mainBackgroundColor
        leftAxis.labelTextColor = .white
        leftAxis.axisLineWidth = 2
        leftAxis.gridColor = Color.mainBackgroundColor

        let rightAxis = barChartView.rightAxis
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisLineColor = Color.mainBackgroundColor
        rightAxis.labelTextColor = .white
        rightAxis.axisLineWidth = 2
        rightAxis.gridColor = Color.mainBackgroundColor

        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        barChartView.animate(xAxisDuration: 0.5)
        barChartView.animate(yAxisDuration: 0.5)
        let legend = barChartView.legend
        legend.textColor = .white
        legend.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        // Add custom legend if available.
        if let labels = labels {
            var legendEntries = [LegendEntry]()
            for (i, each) in labels.enumerated() {
                let entry = LegendEntry()
                entry.label = each
                entry.form = .default
                entry.formColor = dataSet.color(atIndex: i)
                entry.formSize = 8
                legendEntries.append(entry)
            }
            barChartView.legend.setCustom(entries: legendEntries)
        }

        return barChartView
    }

    /// Called to generate a pie chart for this project.
    static func generatePieChart(dataSet: PieChartDataSet, labels: [String]?) -> PieChartView {
        let pieChartView = PieChartView()

        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        dataSet.yValuePosition = .insideSlice

        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.animate(xAxisDuration: 0.5)
        pieChartView.animate(yAxisDuration: 0.5)
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.legend.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        pieChartView.legend.textColor = .white
        pieChartView.drawHoleEnabled = false

        return pieChartView
    }

    /// Called to generate a line graph for this project.
    static func generateLineGraph(dataSet: LineChartDataSet, labels: [String]?) -> LineChartView {
        let lineChartView = LineChartView()

        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont.systemFont(ofSize: 14, weight: .semibold)

        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 0.5)
        lineChartView.animate(yAxisDuration: 0.5)

        return lineChartView
    }

    /// Called to generate a horizontal bar chart for this project.
    static func generateHorizontalBarChart(dataSet: BarChartDataSet, labels: [String]?) -> HorizontalBarChartView {
        let barChartView = HorizontalBarChartView()

        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont.systemFont(ofSize: 14, weight: .semibold)

        let xAxis = barChartView.xAxis
        xAxis.drawLabelsEnabled = false
        xAxis.labelPosition = .bothSided
        xAxis.axisLineColor = Color.mainBackgroundColor
        xAxis.gridColor = Color.mainBackgroundColor
        xAxis.axisLineWidth = 2
        xAxis.granularity = 1

        let leftAxis = barChartView.leftAxis
        leftAxis.drawLabelsEnabled = false
        leftAxis.axisLineColor = Color.mainBackgroundColor
        leftAxis.labelTextColor = .white
        leftAxis.axisLineWidth = 2
        leftAxis.gridColor = Color.mainBackgroundColor

        let rightAxis = barChartView.rightAxis
        rightAxis.axisLineColor = Color.mainBackgroundColor
        rightAxis.labelTextColor = .white
        rightAxis.gridColor = Color.mainBackgroundColor
        rightAxis.axisLineWidth = 2

        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        barChartView.animate(xAxisDuration: 0.5)
        barChartView.animate(yAxisDuration: 0.5)
        let legend = barChartView.legend
        legend.textColor = .white
        legend.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        // Add custom legend if available.
        if let labels = labels {
            var legendEntries = [LegendEntry]()
            for (i, each) in labels.enumerated() {
                let entry = LegendEntry()
                entry.label = each
                entry.form = .default
                entry.formColor = dataSet.color(atIndex: i)
                entry.formSize = 8
                legendEntries.append(entry)
            }
            barChartView.legend.setCustom(entries: legendEntries)
        }

        return barChartView
    }
}
