//
//  SplashScreenVC.swift
//  EveryDutch
//
//  Created by 계은성 on 1/26/24.
//

import UIKit

class SplashScreenVC: UIViewController {
    // MARK: - 프로퍼티
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleRoomDataFetched(notification:)),
            name: .roomDataChanged,
            object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}





// MARK: - 화면 설정
extension SplashScreenVC {
    /// UI 설정
    private func configureUI() {
        self.view.backgroundColor = .red
    }

    /// 클로저 설정
    private func configureClosure() {
        self.viewModel.errorClosure = { [weak self] errorType in
            guard let self = self else { return }
            self.configureError(with: errorType)
        }
    }
}





// MARK: - 화면 이동 함수
extension SplashScreenVC {
    /// 노티피케이션 함수
    @objc private func handleRoomDataFetched(notification: Notification) {
        if let error = notification.userInfo?["error"] as? ErrorEnum {
            self.configureError(with: error)
        } else {
            self.goToMainScreen()
        }
    }
    
    /// 성공 시, MainVC로 이동
    private func goToMainScreen() {
        DispatchQueue.main.async {
            self.coordinator.mainScreen()
        }
    }
    
    /// 에러 설정
    @MainActor
    private func configureError(with errorType: ErrorEnum) {
        switch errorType {
        case .NotLoggedIn:
            self.coordinator.selectALoginMethodScreen()
        case .NoPersonalID:
            self.coordinator.mainToMakeUser()
        default:
            self.coordinator.selectALoginMethodScreen()
        }
    }
}
