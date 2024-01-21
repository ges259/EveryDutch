//
//  PeopleSelectionPanCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/03.
//

import UIKit

final class PeopleSelectionPanCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var nav: UINavigationController
    // WriteScreen_Coordinator로 전달 됨.
    weak var delegate: PeopleSelectionDelegate?
    var selectedUsers: RoomUserDataDictionary?
    var peopleSelectionEnum: PeopleSeelctionEnum?
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    
    
    // MARK: - Start - PeopleSelectionPanVC
    func start() {
        let peopleSelectionPanVM = PeopleSelectionPanVM(
            selectedUsers: self.selectedUsers,
            roomDataManager: RoomDataManager.shared, 
            peopleSelectionEnum: self.peopleSelectionEnum)
        
        let peopleSelectionPanVC = PeopleSelectionPanVC(
            viewModel: peopleSelectionPanVM,
            coordinator: self)
        peopleSelectionPanVC.delegate = self
        peopleSelectionPanVC.modalPresentationStyle = .overFullScreen
        
        self.nav.presentPanModal(peopleSelectionPanVC)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
    }
}

// MARK: - PeopleSelection 델리게이트
extension PeopleSelectionPanCoordinator: PeopleSelectionDelegate {
    func multipleModeSelectedUsers(
        peopleSeelctionEnum: PeopleSeelctionEnum?,
        users: RoomUserDataDictionary) 
    {
        // Receipt_Write_Coordinator로 전달
        self.delegate?.multipleModeSelectedUsers(
            peopleSeelctionEnum: peopleSeelctionEnum,
            users: users)
    }
}
