//
//  InformationTableViewCell.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 3/12/21.
//

import UIKit
import Charts

class InformationTableViewCell: UITableViewCell {

    static let identifier = String(describing: InformationTableViewCell.self)

    // MARK: - IBOutlet connections.
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    // Helper variables.
    private var chartDataSets = [ChartDataSet?]()
    private var chartLabels = [[String]?]()
    private var mainDisplayParameterKeys = [String]()
    private var chartTypes = [ChartType]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupUI() {
        self.backgroundColor = Color.mainBackgroundColor
        infoCollectionView.dataSource = self
        infoCollectionView.delegate = self
        infoCollectionView.backgroundColor = Color.mainBackgroundColor
        infoCollectionView.showsHorizontalScrollIndicator = false
        infoCollectionView.showsVerticalScrollIndicator = false
        infoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        infoCollectionView.collectionViewLayout = layout
        infoCollectionView.register(UINib(nibName: InformationCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: InformationCollectionViewCell.identifier)
    }

    func configureCell(dataSets: [ChartDataSet?], labels: [[String]?], mainDisplayParameterKeys: [String], chartTypes: [ChartType], cellHeight: CGFloat) {
        self.chartDataSets = dataSets
        self.chartLabels = labels
        self.mainDisplayParameterKeys = mainDisplayParameterKeys
        self.chartTypes = chartTypes
        self.heightConstraint.constant = cellHeight

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.infoCollectionView.reloadData()
        }
    }
    
}

extension InformationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartDataSets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InformationCollectionViewCell.identifier, for: indexPath) as! InformationCollectionViewCell
        cell.configureCell(dataSet: chartDataSets[indexPath.row], labels: chartLabels[indexPath.row], mainParameterKeyToDisplay: mainDisplayParameterKeys[indexPath.row], chartType: chartTypes[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = collectionView.bounds.width * 0.90
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
