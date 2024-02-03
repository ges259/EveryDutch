//
//  ProfileEditVCCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

final class ProfileEditVCCoordinator: ProfileEditVCCoordProtocol {
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
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    // MARK: - start
    func start() {
        self.profileEditScreen()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로필 화면
    private func profileEditScreen() {
        let profileEditVM = ProfileEditVM()
        // PlusViewController 인스턴스 생성
        let cardScreenVC = ProfileEditVC(
            viewModel: profileEditVM,
            coordinator: self)
        cardScreenVC.delegate = self
        self.nav.pushViewController(cardScreenVC, animated: true)
    }
    

    
    
    // MARK: - didFinish
    func didFinish() {
        self.nav.popViewController(animated: true)
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    deinit {
        print("\(#function)-----\(self)")
    }
}










extension ProfileEditVCCoordinator: CardScreenDelegate {
    /// CardScreenVC에서 delegate.logout()을 호출 시 실행 됨.
    func logout() {
        self.didFinish()
        (self.parentCoordinator as? MainCoordinator)?.logout()
    }
}
