//
//  RoomEditVCCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 1/30/24.
//

import UIKit

final class RoomEditVCCoordinator: RoomEditVCCoordProtocol {
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
    private var roomEditEnum: RoomEditEnum = .room
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    // 의존성 주입
    init(nav: UINavigationController,
         roomEditEnum: RoomEditEnum) {
        self.nav = nav
        self.roomEditEnum = roomEditEnum
    }
    // MARK: - start
    func start() {
        self.roomEditScreen()
    }
    
    
    
    
    // MARK: - 방 수정 화면
    private func roomEditScreen() {
        let roomEditVM = RoomEditVM(
            profileEditEnum:
            self.roomEditEnum)
        // PlusViewController 인스턴스 생성
        let roomEditVC = RoomEditVC(
            viewModel: roomEditVM,
            coordinator: self)

        self.nav.pushViewController(
            roomEditVC,
            animated: true)
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
