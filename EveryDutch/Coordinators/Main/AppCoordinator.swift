//
//  AppCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

protocol AppCoordProtocol: Coordinator {
    func mainScreen()
    func selectALoginMethodScreen()
}

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
        // SplashScreenVC를 루트 뷰 컨트롤러로 설정하는 방식을 변경하겠습니다.
        let splashScreen = SplashScreenVC(userAPI: UserAPI.shared, coordinator: self)
        
        self.nav.viewControllers = [splashScreen]
    }
    
    
    // MARK: - 메인화면
    /// 메인화면으로 이동
    func mainScreen() {
        self.nav.removeViewControllerOfType(SplashScreenVC.self)
        
        self.nav.dismiss(animated: true)
        let mainCoordinator = MainCoordinator(
            nav: self.nav)
        mainCoordinator.parentCoordinator = self
        self.childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    
    
    // MARK: - 로그인 선택 화면
    func selectALoginMethodScreen() {
        // 로그인 선택 Coordinator 생성 및 시작
        let selectALoginMethodCoord = SelectALoginMethodCoordinator(
            nav: self.nav)
        selectALoginMethodCoord.parentCoordinator = self
        self.childCoordinators.append(selectALoginMethodCoord)
        selectALoginMethodCoord.start()
        
        
        self.transitionAndRemoveVC(
            from: self.nav,
            viewControllerType: SplashScreenVC.self)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
    
    deinit {
        print("deinit --- \(#function)-----\(self)")
    }
}
