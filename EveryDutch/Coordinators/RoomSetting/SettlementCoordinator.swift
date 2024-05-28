//
//  SettlementCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit

//final class SettlementCoordinator: SettlementCoordProtocol {
//    weak var parentCoordinator: Coordinator?
//    
//    var childCoordinators: [Coordinator] = [] {
//        didSet {
//            print("**********SettlementCoordinator**********")
//            dump(childCoordinators)
//            print("********************")
//        }
//    }
//    
//    var nav: UINavigationController
//    
//    // 의존성 주입
//    init(nav: UINavigationController) {
//        self.nav = nav
//    }
//    
//    func start() {
//        let settlementVM = SettlementVM(
//            roomDataManager: RoomDataManager.shared)
//        // SettlementVC 인스턴스 생성
//        let settlementVC = SettlementVC(
//            viewModel: settlementVM,
//            coordinator: self)
//        self.nav.pushViewController(settlementVC, animated: true)
//    }
//    
//    func didFinish() {
//        self.nav.popViewController(animated: true)
//        self.parentCoordinator?.removeChildCoordinator(child: self)
//    }
//    
//    deinit {
//        print("\(#function)-----\(self)")
//    }
//}
