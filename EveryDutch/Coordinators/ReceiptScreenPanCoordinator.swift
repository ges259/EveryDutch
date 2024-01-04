//
//  ReceiptScreenPanCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit

final class ReceiptScreenPanCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    
    func start() {
        let receiptScreenPanVC = ReceiptScreenPanVC(coordinator: self)
        
        receiptScreenPanVC.modalPresentationStyle = .overFullScreen
        
        self.nav.presentPanModal(receiptScreenPanVC)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    
}
