//
//  HistoricalDataTableViewCell.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 30/12/21.
//

import UIKit
import Charts

class HistoricalDataTableViewCell: UITableViewCell {

    /// The identifier for this cell.
    static let identifier = String(describing: HistoricalDataTableViewCell.self)

    // MARK: - IBOutlet connections.
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!

    // The chartView so that it can be tracked.
    var chartView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setupUI() {
        chartContainerView.layer.cornerRadius = 25
        chartContainerView.clipsToBounds = true
        chartContainerView.backgroundColor = Color.mainChartBackgroundColor
    }

    func configureCell(cellHeight: CGFloat, dataSets: [LineChartDataSet?]) {
        // Remove any previous chart.
        chartView?.removeFromSuperview()

        // Set height.
        cellHeightConstraint.constant = cellHeight

        let lineGraphView = ChartGenerator.generateLineGraph(dataSets: dataSets.compactMap({ $0 }), labels: nil)
        addChartToCell(chartView: lineGraphView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func addChartToCell(chartView: UIView) {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.addSubview(chartView)
        NSLayoutConstraint.activate([chartView.leftAnchor.constraint(equalTo: chartContainerView.leftAnchor, constant: 16), chartView.rightAnchor.constraint(equalTo: chartContainerView.rightAnchor, constant: -16), chartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: 16), chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -16)])
        self.chartView = chartView
    }
    
}
