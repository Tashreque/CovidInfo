//
//  ViewController.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 6/11/21.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: - IBOutlet connections
    @IBOutlet weak var tableViewContainerView: UIView!
    @IBOutlet weak var informationTableView: UITableView!
    @IBOutlet weak var navigationBarContainerView: UIView!
    @IBOutlet weak var navigationBarView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = Color.mainBackgroundColor
        navigationBarContainerView.backgroundColor = Color.mainBackgroundColor
        navigationBarView.backgroundColor = Color.mainBackgroundColor
        tableViewContainerView.backgroundColor = Color.mainBackgroundColor

        informationTableView.delegate = self
        informationTableView.dataSource = self
        informationTableView.backgroundColor = .clear
        informationTableView.separatorStyle = .none
    }


}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if indexPath.row > 0 {
            cell.contentView.backgroundColor = .orange
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableViewContainerView.bounds.height
        default:
            return 200
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let backgroundView = UIView(frame: cell.bounds)
            backgroundView.backgroundColor = .clear
            cell.backgroundView = backgroundView
        }
    }
}

