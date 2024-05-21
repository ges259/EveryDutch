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
            print("**********\(self)**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    deinit { print("\(#function)-----\(self)") }
    
    
    
    // MARK: - 라이프사이클
    func start() {
        self.selectALoginMethodScreen()
    }
    
    // MARK: - 로그인 선택 화면
    private func selectALoginMethodScreen() {
        DispatchQueue.main.async {
            let selectALoginMethodVM = SelectALoginMethodVM(
                authAPI: AuthAPI.shared)
            
            let selectALoginMethodVC = SelectALoginMethodVC(
                viewModel: selectALoginMethodVM,
                coordinator: self)
            
            let selectALoginMethodNav = UINavigationController(
                rootViewController: selectALoginMethodVC)
            
            selectALoginMethodNav.modalPresentationStyle = .fullScreen
            
            let animated = self.nav.topViewController is MainVC
            
            self.nav.present(selectALoginMethodNav,
                             animated: animated)
            
            // 네비게이션 컨트롤러 참조 저장
            self.nav = selectALoginMethodNav
        }
    }
    
    
    // MARK: - 메인 화면
    /// MainVC로 이동
    func navigateToMain() {
        DispatchQueue.main.async {
            let mainCoordinator = MainCoordinator(
                nav: self.nav)
            self.childCoordinators.append(mainCoordinator)
            
            mainCoordinator.parentCoordinator = self
            mainCoordinator.start()
            
            self.transitionAndRemoveVC(
                from: self.nav,
                viewControllerType: SelectALoginMethodVC.self)
        }
    }
    
    
    // MARK: - 유저 생성 화면
    /// MainVC를 거쳐 EditScreenVC로 이동
    func mainToMakeUser() {
        DispatchQueue.main.async {
            let mainCoordinator = MainCoordinator(nav: self.nav)
            self.childCoordinators.append(mainCoordinator)
            mainCoordinator.parentCoordinator = self
            mainCoordinator.startMakeUser()
            self.transitionAndRemoveVC(
                from: self.nav,
                viewControllerType: SelectALoginMethodVC.self)
        }
    }
    
    func didFinish() {
        // 필요한 경우 여기에서 추가적인 정리 작업을 수행
        // 자식 코디네이터를 부모의 배열에서 제거
        // 즉, PlusBtnCoordinator이 MainCoordinator의 childCoordinators 배열에서 제거
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
}
