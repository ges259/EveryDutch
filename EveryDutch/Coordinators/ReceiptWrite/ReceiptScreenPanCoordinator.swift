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
    
    var receipt: Receipt
    
    var roomUsers: [RoomUsers]
    
    // 의존성 주입
    init(nav: UINavigationController,
         receipt: Receipt,
         users: [RoomUsers]) {
        self.nav = nav
        self.receipt = receipt
        self.roomUsers = users
    }
    
    
    func start() {
        let receiptScreenPanVM = ReceiptScreenPanVM(
            receipt: self.receipt, 
            users: self.roomUsers)
        let receiptScreenPanVC = ReceiptScreenPanVC(
            coordinator: self,
            viewModel: receiptScreenPanVM)
        
        receiptScreenPanVC.modalPresentationStyle = .overFullScreen
        
        self.nav.presentPanModal(receiptScreenPanVC)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    
}
