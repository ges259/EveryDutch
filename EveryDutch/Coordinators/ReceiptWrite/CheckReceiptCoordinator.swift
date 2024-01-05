//
//  CheckReceiptCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/05.
//

import UIKit

final class CheckReceiptCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let checkReceiptPanVC = CheckReceiptPanVC(coordinator: self)
        
        checkReceiptPanVC.modalPresentationStyle = .overFullScreen
        
        self.nav.presentPanModal(checkReceiptPanVC)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)

    }
    deinit {
        print("deinit ----- \(#function)-----\(self)")

    }
    
}
