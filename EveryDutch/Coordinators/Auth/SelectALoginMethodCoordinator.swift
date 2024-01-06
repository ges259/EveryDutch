//
//  SelectALoginMethodCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import UIKit

final class SelectALoginMethodCoordinator: SelectALoginMethodCoordProtocol {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********SelectALoginMethodCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    var modalNavController: UINavigationController?

    func start() {
        let selectALoginMethodVC = SelectALoginMethodVC(coordinator: self)
        let selectALoginMethodNav = UINavigationController(rootViewController: selectALoginMethodVC)
        selectALoginMethodNav.modalPresentationStyle = .fullScreen
        self.nav.present(selectALoginMethodNav, animated: false)
        // 네비게이션 컨트롤러 참조 저장
        self.modalNavController = selectALoginMethodNav
    }
    func loginScreen() {
        let loginScreenCoordinator = LoginScreenCoordinator(nav: self.modalNavController ?? self.nav)
        self.childCoordinators.append(loginScreenCoordinator)
        loginScreenCoordinator.parentCoordinator = self
        loginScreenCoordinator.start()
    }
    
    func didFinish() {
        // 현재 표시된 뷰 컨트롤러를 dismiss
        self.nav.dismiss(animated: true) {
            // 필요한 경우 여기에서 추가적인 정리 작업을 수행
            // 자식 코디네이터를 부모의 배열에서 제거
                // 즉, PlusBtnCoordinator이 MainCoordinator의 childCoordinators 배열에서 제거
            self.parentCoordinator?.removeChildCoordinator(child: self)
        }
    }
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
