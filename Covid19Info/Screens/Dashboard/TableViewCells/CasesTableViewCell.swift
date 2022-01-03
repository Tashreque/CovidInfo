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
        casesTitleLabel.textColor = Color.purpleTextColor
        casesValueLabel.textColor = Color.purpleTextColor
    }

    func configureCell(title: String, value: Int?) {
        casesTitleLabel.text = title
        casesValueLabel.text = "\(value ?? 0)"
    }
    
}
