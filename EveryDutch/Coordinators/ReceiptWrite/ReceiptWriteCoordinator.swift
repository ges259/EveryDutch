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
    
    // MARK: - Start - ReceiptWriteVC
    func start() {
        let receiptWriteVM = ReceiptWriteVM(
            roomDataManager: RoomDataManager.shared, 
            receiptAPI: ReceiptAPI.shared)
        
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
    
    
    
    // MARK: - PeopleSelectionPanScreen
    func peopleSelectionPanScreen(
        users: RoomUserDataDict?,
        peopleSelectionEnum: PeopleSeelctionEnum?)
    {
        // PeopleSelectionPanCoordinator 생성
        let peopleSelectionPanCoord = PeopleSelectionPanCoordinator(
            nav: self.modalNavController ?? self.nav)
        self.childCoordinators.append(peopleSelectionPanCoord)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        peopleSelectionPanCoord.parentCoordinator = self
        // ***** 델리게이트 설정 *****
        peopleSelectionPanCoord.delegate = self
        // 데이터 전달
        peopleSelectionPanCoord.selectedUsers = users
        peopleSelectionPanCoord.peopleSelectionEnum = peopleSelectionEnum
        
        // 코디네이터에게 화면이동을 지시
        peopleSelectionPanCoord.start()
    }
    
    
    // MARK: - CheckReceiptPanScreen
    func checkReceiptPanScreen(_ validationDict: [String: Any?]) {
        // CheckReceiptCoordinator 생성
        let checkReceiptCoordinator = CheckReceiptCoordinator(
            nav: self.modalNavController ?? self.nav,
            validationDict: validationDict)
        self.childCoordinators.append(checkReceiptCoordinator)
        // 부모 코디네이터가 자신이라는 것을 명시 (뒤로가기 할 때 필요)
        checkReceiptCoordinator.parentCoordinator = self
        // 코디네이터에게 화면이동을 지시
        checkReceiptCoordinator.start()
    }
    
    
    // MARK: - didFinish
    func didFinish() {
        DispatchQueue.main.async {
            // 현재 표시된 뷰 컨트롤러를 dismiss
            self.modalNavController?.dismiss(animated: true) {
                // 필요한 경우 여기에서 추가적인 정리 작업을 수행
                // 자식 코디네이터를 부모의 배열에서 제거
                    // 즉, SettlementVC이 RoomSettingCoordinator의 childCoordinators 배열에서 제거
                self.parentCoordinator?.removeChildCoordinator(child: self)
            }
        }
    }
    
    deinit {
        print("\(#function)-----\(self)")
    }
}


// MARK: - PeopleSelection 델리게이트
extension ReceiptWriteCoordinator: PeopleSelectionDelegate {
    
    func multipleModeSelectedUsers(
        addedusers: RoomUserDataDict,
        removedUsers: RoomUserDataDict)
    {
        if let receiptWriteVC = self.findReceiptWriteVC {
            receiptWriteVC.changeTableViewData(
                addedUsers: addedusers,
                removedUsers: removedUsers)
        }
    }
    
    func payerSelectedUser(
        addedUser: RoomUserDataDict)
    {
        if let receiptWriteVC = self.findReceiptWriteVC {
            receiptWriteVC.changePayerLblData(addedUsers: addedUser)
        }
    }
    
    
    // 공통된 ReceiptWriteVC 찾기 로직
    private var findReceiptWriteVC: ReceiptWriteVC? {
        return self.modalNavController?
            .viewControllers
            .first(where: { $0 is ReceiptWriteVC }) as? ReceiptWriteVC
    }
}
