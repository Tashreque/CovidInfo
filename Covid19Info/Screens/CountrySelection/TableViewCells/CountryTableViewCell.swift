//
//  CountryTableViewCell.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 10/12/21.
//

import UIKit
import SDWebImage

class CountryTableViewCell: UITableViewCell {

    /// The identifier for this cell.
    static let identifier = String(describing: CountryTableViewCell.self)

    // MARK: - IBOutlet connections.
    @IBOutlet weak var flagImageView: SDAnimatedImageView!
    @IBOutlet weak var countryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        setupUI()
    }

    private func setupUI() {
        countryNameLabel.numberOfLines = 0
    }

    func configureCell(name: String, iconUrlString: String) {
        countryNameLabel.text = name
        flagImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        if let url = URL(string: iconUrlString) {
            flagImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}
