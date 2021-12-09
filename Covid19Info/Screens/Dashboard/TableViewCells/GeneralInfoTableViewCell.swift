//
//  GeneralInfoTableViewCell.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/12/21.
//

import UIKit

class GeneralInfoTableViewCell: UITableViewCell {

    // MARK: - IBOutlet connections.
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    /// The cell identifier.
    static let identifier = String(describing: GeneralInfoTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        keyLabel.numberOfLines = 0
        valueLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(keyString: String, valueString: String) {
        keyLabel.text = keyString
        valueLabel.text = valueString
    }
    
}
