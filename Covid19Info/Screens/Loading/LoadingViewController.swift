//
//  LoadingViewController.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 8/12/21.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        // Set the default background alpha.
        self.view.backgroundColor = Color.mainBackgroundColor

        // Add activity container view.
        let activityIndicatorContainerView = UIView()
        activityIndicatorContainerView.backgroundColor = Color.mainChartBackgroundColor
        activityIndicatorContainerView.alpha = 0.80
        activityIndicatorContainerView.layer.cornerRadius = 10
        self.view.addSubview(activityIndicatorContainerView)
        activityIndicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([activityIndicatorContainerView.heightAnchor.constraint(equalToConstant: 100), activityIndicatorContainerView.widthAnchor.constraint(equalToConstant: 150), activityIndicatorContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), activityIndicatorContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])

        // Add activity indicator view.
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.color = Color.mainBackgroundColor
        activityIndicatorContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([activityIndicatorView.centerXAnchor.constraint(equalTo: activityIndicatorContainerView.centerXAnchor), activityIndicatorView.centerYAnchor.constraint(equalTo: activityIndicatorContainerView.centerYAnchor)])
        activityIndicatorView.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // Called to dismiss the loading indicator view controller.
    func dismissLoadingScreen() {
        self.dismiss(animated: true, completion: nil)
    }

}
