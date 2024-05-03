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
    private var validationDict = [String]()
    private let receiptCheckType: ReceiptCheckEnum
    
    // 의존성 주입
    init(nav: UINavigationController,
         type: ReceiptCheckEnum,
         validationDict: [String]) {
        self.nav = nav
        self.receiptCheckType = type
        self.validationDict = validationDict
    }
    
    func start() {
        let checkReceiptPanVM = CheckReceiptPanVM(
            type: self.receiptCheckType,
            validationDict: self.validationDict)
        
        let checkReceiptPanVC = CheckReceiptPanVC(
            viewModel: checkReceiptPanVM,
            coordinator: self)
        
        checkReceiptPanVC.modalPresentationStyle = .overFullScreen
        
        self.nav.presentPanModal(checkReceiptPanVC)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("\(#function)-----\(self)")
    }
}
