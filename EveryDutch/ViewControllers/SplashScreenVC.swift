//
//  SplashScreenVC.swift
//  EveryDutch
//
//  Created by 계은성 on 1/26/24.
//

import UIKit

class SplashScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .red

        
    }
    private let userAPI: UserAPI
    
    init(userAPI: UserAPI) {
        self.userAPI = userAPI
        super.init(nibName: nil, bundle: nil)
        
        self.userAPI.checkLogin { [weak self] result in
            switch result {
            case .success(let user):
                // 로그인 성공, 메인 화면으로 이동
                break
            case .failure:
                // 로그인 실패, 로그인 화면으로 이동
//                self?.navigateToLoginScreen()
                break
                
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func checkLogin(completion: @escaping (Result<User, AuthError>) -> Void) {
//        if let currentUser = Auth.auth().currentUser {
//            // 이미 로그인된 상태
//            self.readUser(uid: currentUser.uid, completion: completion)
//        } else {
//            // 로그인이 되어있지 않은 상태
//            completion(.failure(.loginError))
//        }
//    }

    // 사용자 정보를 읽는 함수
//    func readUser(uid: String, completion: @escaping (Result<User, AuthError>) -> Void) {
//        // Firebase에서 사용자 정보를 읽는 코드
//        // 성공 시 completion(.success(user)) 호출
//        // 실패 시 completion(.failure(.readError)) 호출
//    }

    // 메인 화면으로 이동하는 함수
    func navigateToMainScreen(user: User) {
        // 메인 화면으로 이동하는 코드
    }

    // 로그인 화면으로 이동하는 함수
    func navigateToLoginScreen() {
        // 로그인 화면으로 이동하는 코드
    }
}
