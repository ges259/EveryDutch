//
//  SplashScreenVC.swift
//  EveryDutch
//
//  Created by 계은성 on 1/26/24.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    
    private var viewModel: SplashScreenVMProtocol
    private let coordinator: AppCoordProtocol
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()          // UI 설정
        self.configureClosure()     // 클로져 설정
        self.viewModel.checkLogin() // 로그인 확인
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
    deinit { print("\(#function)-----\(self)") }
}










// MARK: - 기본 설정

extension SplashScreenVC {
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.view.backgroundColor = .base_Blue
    }
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        self.viewModel.successClosure = { [weak self] in
            self?.configureSuccess()
        }
        self.viewModel.errorClosure = { [weak self] errorType in
            self?.configureError(with: errorType)
        }
    }
}










// MARK: - 화면 이동

extension SplashScreenVC {
    
    // MARK: - 성공 시 메인 화면으로 이동
    private func configureSuccess() {
        self.coordinator.mainScreen()
    }
    
    // MARK: - 에러 설정
    private func configureError(with errorType: ErrorEnum) {
        switch errorType {
        case .NotLoggedIn:
            // MARK: - 유저 생성 화면으로 이동
            self.coordinator.selectALoginMethodScreen()
            break
            
            // MARK: - 로그인 선택 화면으로 이동
        case .NoPersonalID:
            self.coordinator.mainToMakeUser()
            break
            
        default:
            self.coordinator.selectALoginMethodScreen()
            break
        }
    }
}
