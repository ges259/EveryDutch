//
//  LoginScreenCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import UIKit

//final class LoginScreenCoordinator: LoginScreenCoordProtocol {
//    weak var parentCoordinator: Coordinator?
//    
//    var childCoordinators: [Coordinator] = [] {
//        didSet {
//            print("**********LoginScreenCoordinator**********")
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
//        // LoginVC 인스턴스 생성
//        let loginVC = LoginVC(coordinator: self)
//        // push를 통해 화면 이동
//        self.nav.pushViewController(loginVC, animated: true)
//    }
//    func SignUpScreen() {
//        // SettleMoneyRoomCoordinator 생성
//        let signUpScreenCoordinator = SignUpScreenCoordinator(nav: self.nav)
//        
//        self.childCoordinators.append(signUpScreenCoordinator)
//        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
//        signUpScreenCoordinator.parentCoordinator = self
//        signUpScreenCoordinator.start()
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
