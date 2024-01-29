//
//  SplashScreenVC.swift
//  EveryDutch
//
//  Created by 계은성 on 1/26/24.
//

import UIKit

class SplashScreenVC: UIViewController {
    

    private let viewModel: SplashScreenVMProtocol
    private let coordinator: AppCoordProtocol
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .base_Blue
        
        self.checkLogin()
    }
    init(viewModel: SplashScreenVMProtocol,
         coordinator: AppCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit --- \(#function)-----\(self)")
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 로그인 확인
    private func checkLogin() {
        self.viewModel.checkLogin { [weak self] bool in
            _ = bool
            ? self?.goToMainScreen()
            : self?.goToLoginScreen()
        }
    }
    
    // MARK: - 메인 화면으로 이동
    // 메인 화면으로 이동하는 함수
    private func goToMainScreen() {
        // MARK: - Fix 유저 fetch
        self.coordinator.mainScreen()
    }
    
    // MARK: - 로그인 선택 화면으로 이동
    // 로그인 화면으로 이동하는 함수
    private func goToLoginScreen() {
            // 로그인 화면으로 이동하는 코드
        self.coordinator.selectALoginMethodScreen()
    }
}
