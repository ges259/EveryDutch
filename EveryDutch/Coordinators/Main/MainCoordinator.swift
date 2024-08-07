//
//  MainCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

// MARK: - MainViewController
final class MainCoordinator: MainCoordProtocol{
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********\(self)**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    var user: User?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    
    // MARK: - start
    // MainViewController 띄우기
    func start() {
        self.mainScreen()
    }
    func startMakeUser() {
        self.mainScreen()
        self.profileEditScreen()
    }
    
    
    // MARK: - 메인 화면
    private func mainScreen() {
        // 뷰모델 인스턴스 생성 (이 부분이 추가됨)
        let mainViewModel = MainVM(roomDataManager: RoomDataManager.shared)
        // 뷰컨트롤러 인스턴스 생성 및 뷰모델 주입
        let mainVC = MainVC(viewModel: mainViewModel,
                            coordinator: self)
        let mainVCNav = UINavigationController(
            rootViewController: mainVC)
        
        mainVCNav.modalPresentationStyle = .fullScreen
        
        let animated = self.nav.topViewController is SelectALoginMethodVC
        // 화면 전환
        self.nav.present(mainVCNav, animated: animated)
        // 네비게이션 컨트롤러 참조 저장
        self.nav = mainVCNav
    }
    
    
    
    // MARK: - 정산방
    /// 채팅방으로 이동
    func settlementMoneyRoomScreen() {
        // SettleMoneyRoomCoordinator 생성
        let settlementRoomCoordinator = SettleMoneyRoomCoordinator(
            nav: self.nav)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
            settlementRoomCoordinator.parentCoordinator = self
        self.childCoordinators.append(settlementRoomCoordinator)
            settlementRoomCoordinator.start()
    }
    

    
    // MARK: - 프로필 화면 스크린
    func profileScreen() {
        let profileCoordinator = ProfileCoordinator(
            nav: self.nav)
        self.childCoordinators.append(profileCoordinator)
        profileCoordinator.parentCoordinator = self
        profileCoordinator.start()
    }
    
    
    
    
    
    // MARK: - EditScreen
    /// 프로필 생성 화면,
    /// 첫 로그인 시 유저의 프로필을 생성할  때,
    func profileEditScreen() {
        // Main-Coordinator 생성
        let editScreenVCCoordinator = EditScreenCoordinator(
            nav: self.nav,
            isUserDataMode: true,
            isFistLoginMakeUser: true,
            providerTuple: nil)
        self.moveToEditScreenVCCoord(to: editScreenVCCoordinator)
    }
    
    
    
    // MARK: - 방 수정 스크린 (생성)
    /// 플러스 버튼을 누르면 화면 이동
    func roomEditScreen() {
        // Main-Coordinator 생성
        let editScreenVCCoordinator = EditScreenCoordinator(
            nav: self.nav,
            isUserDataMode: false, 
            providerTuple: nil)
        self.moveToEditScreenVCCoord(to: editScreenVCCoordinator)
    }
    
    
    
    // MARK: - 수정 화면 이동 클로저
    private func moveToEditScreenVCCoord(
        to editScreenVCCoordinator: EditScreenCoordinator)
    {
        self.childCoordinators.append(editScreenVCCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        editScreenVCCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        editScreenVCCoordinator.start()
    }
    
    
    
    // MARK: - 로그인 선택 화면
    func selectALgoinMethodScreen() {
        DispatchQueue.main.async {
            // SettleMoneyRoomCoordinator 생성
            let selectALoginMethodCoordinator = SelectALoginMethodCoordinator(
                nav: self.nav)
            self.childCoordinators.append(selectALoginMethodCoordinator)
            // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
            selectALoginMethodCoordinator.parentCoordinator = self
            selectALoginMethodCoordinator.start()
            
            self.transitionAndRemoveVC(
                from: self.nav,
                viewControllerType: MainVC.self)
        }
    }
    
    
    
    // MARK: - didFinish
    func didFinish() {
        // 필요한 경우 여기에서 추가적인 정리 작업을 수행
        // 자식 코디네이터를 부모의 배열에서 제거
        // 즉, PlusBtnCoordinator이 MainCoordinator의 childCoordinators 배열에서 제거
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
}










//    func logout() {
//        self.selectALgoinMethodScreen()
//    }
