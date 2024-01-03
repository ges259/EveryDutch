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
    
    // 의존성 주입
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    
    func start() {
        let peopleSelectionPanVC = PeopleSelectionPanVC(coordinator: self)
        
        peopleSelectionPanVC.modalPresentationStyle = .overFullScreen
//        peopleSelectionPanVC.modalPresentationStyle = .fullScreen
        
        self.nav.presentPanModal(peopleSelectionPanVC)
//        self.nav.present(peopleSelectionPanVC, animated: true)
    }
    
    func didFinish() {
        self.parentCoordinator?.removeChildCoordinator(child: self)
        
    }
    
    
}
