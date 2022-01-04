//
//  UIViewController+Extension.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 5/1/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoadingScreen() -> LoadingViewController {
        let loadingScreenVC = LoadingViewController()
        loadingScreenVC.modalTransitionStyle = .crossDissolve
        loadingScreenVC.modalPresentationStyle = .overFullScreen
        self.present(loadingScreenVC, animated: true, completion: nil)
        return loadingScreenVC
    }
}
