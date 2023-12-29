//
//  FindFriendsCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/30.
//

import UIKit

final class FindFriendsCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        // FindFriendsVC 인스턴스 생성
        let findFriendsVC = FindFriendsVC(coordinator: self)
        let findFriendsVCNav = UINavigationController(rootViewController: findFriendsVC)
        findFriendsVCNav.modalPresentationStyle = .fullScreen
        // push를 통해 화면 이동
        self.nav.present(findFriendsVCNav, animated: true)
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
    
    
}
