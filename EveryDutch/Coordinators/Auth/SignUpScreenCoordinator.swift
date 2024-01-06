//
//  SignUpScreenCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import UIKit

final class SignUpScreenCoordinator: SignUpScreenCoordProtocol {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********SignUpScreenCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        // PlusViewController 인스턴스 생성
        let signUpVC = SignUpVC(coordinator: self)
        // push를 통해 화면 이동
        self.nav.pushViewController(signUpVC, animated: true)
    }
    
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
