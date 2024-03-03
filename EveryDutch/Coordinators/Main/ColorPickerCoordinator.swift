//
//  ColorPickerCoordinator.swift
//  EveryDutch
//
//  Created by 계은성 on 3/3/24.
//

import UIKit

//final class ColorPickerCoordinator: Coordinator {
//    var parentCoordinator: Coordinator?
//    
//    var childCoordinators: [Coordinator] = []
//    
//    var nav: UINavigationController
//    
//    weak var delegate: ColorPickerDelegate?
//    
//    
//    
//    
//    
//    // MARK: - 라이프사이클
//    // 의존성 주입
//    init(nav: UINavigationController) {
//        self.nav = nav
//    }
//    
//    // MARK: - start
//    func start() {
//        self.colorPickerScreen()
//    }
//    
//    // MARK: - 색상 선택 화면
//    private func colorPickerScreen() {
//        let colorPickerVC = ColorPickerVC(coordinator: self)
//        colorPickerVC.delegate = self
//        self.nav.present(colorPickerVC, animated: true)
//    }
//    
//    // MARK: - didFinish
//    func didFinish() {
//        self.nav.dismiss(animated: true) {
//            self.parentCoordinator?.removeChildCoordinator(child: self)
//        }
//    }
//}
//
//
//
//
//extension ColorPickerCoordinator: ColorPickerDelegate {
//    func colorPicked(_ color: UIColor) {
//        self.didFinish()
//        self.delegate?.colorPicked(color)
//    }
//}
