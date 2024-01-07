//
//  PlusBtnCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

final class CardScreenCoordinator: CardScreenCoordProtocol {
    weak var parentCoordinator: Coordinator?

    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********MultipurposeScreenCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    weak var delegate: MultiPurposeScreenDelegate?
    
    var nav: UINavigationController
    private var cardScreen_Enum: CardScreen_Enum = .profile
    
    // 의존성 주입
    init(nav: UINavigationController,
         cardScreen_Enum: CardScreen_Enum) {
        self.nav = nav
        self.cardScreen_Enum = cardScreen_Enum
    }
    
    func start() {
        let multipurposeScreenVM = CardScreenVM(
            cardScreen_Enum: self.cardScreen_Enum)
        // PlusViewController 인스턴스 생성
        let multipurposeScreenVC = CardScreenVC(
            viewModel: multipurposeScreenVM,
            coordinator: self)
        multipurposeScreenVC.delegate = self
        self.nav.pushViewController(multipurposeScreenVC, animated: true)
    }
    

    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}


extension CardScreenCoordinator: MultiPurposeScreenDelegate {
    func logout() {
        self.didFinish()
        (self.parentCoordinator as? MainCoordinator)?.logout()
    }
}
