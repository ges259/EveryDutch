//
//  AppCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

// MARK: - AppCoordinator
final class AppCoordinator: AppCoordProtocol {
    
    // 순환 참조 방지, weak 사용
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********\(self)**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    
    // MARK: - Start
    func start() {
        self.splashScreen()
    }
    
    
    // MARK: - 스플레시 화면
    func splashScreen() {
        
        let splashScreenVM = SplashScreenVM(
            authAPI: AuthAPI.shared,
            roomDataManager: RoomDataManager.shared)
        
        // SplashScreenVC를 루트 뷰 컨트롤러로 설정하는 방식
        let splashScreenVC = SplashScreenVC(
            viewModel: splashScreenVM,
            coordinator: self)
        
        self.nav.viewControllers = [splashScreenVC]
    }
    
    
    // MARK: - 메인화면
    /// 메인화면으로 이동
    func mainScreen() {
        
        let mainCoordinator = MainCoordinator(
            nav: self.nav)
        // 유저
        
        mainCoordinator.parentCoordinator = self
        self.childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        self.transitionAndRemoveSplashVC()
    }
    
    func mainToMakeUser() {
        let mainCoordinator = MainCoordinator(
            nav: self.nav)
        self.childCoordinators.append(mainCoordinator)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.startMakeUser()
        self.transitionAndRemoveSplashVC()
    }
    
    // MARK: - 로그인 선택 화면
    func selectALoginMethodScreen() {
        // 로그인 선택 Coordinator 생성 및 시작
        let selectALoginMethodCoord = SelectALoginMethodCoordinator(
            nav: self.nav)
        selectALoginMethodCoord.parentCoordinator = self
        self.childCoordinators.append(selectALoginMethodCoord)
        selectALoginMethodCoord.start()
        
        self.transitionAndRemoveSplashVC()
    }
    
    
    
    // MARK: - 스플레시 화면 제거
    private func transitionAndRemoveSplashVC() {
        self.transitionAndRemoveVC(
            from: self.nav,
            viewControllerType: SplashScreenVC.self)
    }
    
    
    // MARK: - didFinish
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    deinit {
        print("\(#function)-----\(self)")
    }
}
