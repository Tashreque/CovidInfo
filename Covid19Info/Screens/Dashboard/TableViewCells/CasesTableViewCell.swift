//
//  CasesTableViewCell.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 30/12/21.
//

import UIKit

class CasesTableViewCell: UITableViewCell {

    /// The identifier for this cell.
    static let identifier = String(describing: CasesTableViewCell.self)

    // MARK: - IBOutlet connections.
    @IBOutlet weak var casesTitleLabel: UILabel!
    @IBOutlet weak var casesValueLabel: UILabel!
    @IBOutlet weak var recoveredTitleLabel: UILabel!
    @IBOutlet weak var recoveredValueLabel: UILabel!
    @IBOutlet weak var deathTitleLabel: UILabel!
    @IBOutlet weak var deathValueLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

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
        casesTitleLabel.numberOfLines = 0
        casesTitleLabel.textColor = Color.mainBackgroundColor
        casesValueLabel.textColor = .yellow
        recoveredTitleLabel.textColor = Color.mainBackgroundColor
        recoveredValueLabel.textColor = .green
        deathTitleLabel.textColor = Color.mainBackgroundColor
        deathValueLabel.textColor = .red

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 40
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func configureCell(casesTitle: String, casesValue: Int?, recoveredTitle: String, recoveredValue: Int?, deathTitle: String, deathValue: Int?) {
        casesTitleLabel.text = casesTitle
        casesValueLabel.text = "\(casesValue ?? 0)"
        recoveredTitleLabel.text = recoveredTitle
        recoveredValueLabel.text = "\(recoveredValue ?? 0)"
        deathTitleLabel.text = deathTitle
        deathValueLabel.text = "\(deathValue ?? 0)"
    }
    
}
