//
//  UINavigationController+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 1/28/24.
//

import UIKit

extension UINavigationController {
    func removeViewControllerOfType<T: UIViewController>(_ type: T.Type) {
        self.viewControllers.removeAll(where: { $0 is T })
    }
}
