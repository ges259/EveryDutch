//
//  SettlementCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit

final class SettlementCoordinator: SettlementCoordProtocol {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********SettlementCoordinator**********")
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
        // SettlementVC 인스턴스 생성
        let settlementVC = SettlementVC(coordinator: self)
        // 네비게이션 컨트롤러 생성 및 루트 뷰 컨트롤러 설정
        let settlementVCNav = UINavigationController(rootViewController: settlementVC)
        // 전체 화면 꽉 채우기
        settlementVCNav.modalPresentationStyle = .fullScreen
        // 모달로 네비게이션 컨트롤러를 표시
        self.nav.present(settlementVCNav, animated: true)
    }
    
    func didFinish() {
        // 현재 표시된 뷰 컨트롤러를 dismiss
        self.nav.dismiss(animated: true) {
            // 필요한 경우 여기에서 추가적인 정리 작업을 수행
            // 자식 코디네이터를 부모의 배열에서 제거
                // 즉, SettlementVC이 RoomSettingCoordinator의 childCoordinators 배열에서 제거
            self.parentCoordinator?.removeChildCoordinator(child: self)
        }
    }
    
    deinit {
        print("deinit ----- \(#function)-----\(self)")
    }
}
