//
//  ReceiptWriteCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/01.
//

import UIKit

final class ReceiptWriteCoordinator: ReceiptWriteCoordProtocol {
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = [] {
        didSet {
            print("**********ReceiptWriteCoordinator**********")
            dump(childCoordinators)
            print("********************")
        }
    }
    
    var nav: UINavigationController
    var modalNavController: UINavigationController?
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let receiptWriteVM = ReceiptWriteVM(
            roomDataManager: RoomDataManager.shared)
        
        // SettlementVC 인스턴스 생성
        let receiptWriteVC = ReceiptWriteVC(
            viewModel: receiptWriteVM,
            coordinator: self)
        // 네비게이션 컨트롤러 생성 및 루트 뷰 컨트롤러 설정
        let receiptWriteNavController = UINavigationController(rootViewController: receiptWriteVC)
        // 전체 화면 꽉 채우기
        receiptWriteNavController.modalPresentationStyle = .fullScreen
        // 모달로 네비게이션 컨트롤러를 표시
        self.nav.present(receiptWriteNavController, animated: true)
        // 네비게이션 컨트롤러 참조 저장
        self.modalNavController = receiptWriteNavController
    }
    func peopleSelectionPanScreen() {
        // PeopleSelectionPanCoordinator 생성
        let peopleSelectionPanCoordinator = PeopleSelectionPanCoordinator(
            nav: self.modalNavController ?? self.nav)
        self.childCoordinators.append(peopleSelectionPanCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        peopleSelectionPanCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        peopleSelectionPanCoordinator.start()
    }
    
    func checkReceiptPanScreen() {
        // CheckReceiptCoordinator 생성
        let checkReceiptCoordinator = CheckReceiptCoordinator(
            nav: self.modalNavController ?? self.nav)
        self.childCoordinators.append(checkReceiptCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        checkReceiptCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        checkReceiptCoordinator.start()
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
