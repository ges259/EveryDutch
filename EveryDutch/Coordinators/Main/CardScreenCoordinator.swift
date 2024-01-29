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
    // MainCoordinator에서 설정
    weak var delegate: CardScreenDelegate?
    
    var nav: UINavigationController
    private var cardScreen_Enum: CardScreen_Enum = .profile
    
    // 의존성 주입
    init(nav: UINavigationController,
         cardScreen_Enum: CardScreen_Enum) {
        self.nav = nav
        self.cardScreen_Enum = cardScreen_Enum
    }
    
    func start() {
        let cardScreenVM = CardScreenVM(
            cardScreen_Enum: self.cardScreen_Enum)
        // PlusViewController 인스턴스 생성
        let cardScreenVC = CardScreenVC(
            viewModel: cardScreenVM,
            coordinator: self)
        cardScreenVC.delegate = self
        self.nav.pushViewController(cardScreenVC, animated: true)
    }
    

    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    deinit {
        print("\(#function)-----\(self)")
    }
}


extension CardScreenCoordinator: CardScreenDelegate {
    /// CardScreenVC에서 delegate.logout()을 호출 시 실행 됨.
    func logout() {
        self.didFinish()
        (self.parentCoordinator as? MainCoordinator)?.logout()
    }
}
