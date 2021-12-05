//
//  UIView+ContextualChanges.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 10/11/21.
//

import Foundation
import UIKit

extension UIView {
    func addBorder(color: UIColor?, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
    }
}
