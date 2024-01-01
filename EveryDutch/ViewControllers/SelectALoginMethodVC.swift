//
//  SelectALoginMethodVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import UIKit
import SnapKit

final class SelectALoginMethodVC: UIViewController {
    // MARK: - 레이아웃
    // 앱 아이콘
//    private lazy var iconImg: UIImageView = UIImageView(image: UIImage(named: "icon"))
    
    /// 애플 로그인 버튼
    private lazy var appleLogin: UIButton = UIButton.btnWithTitle(
        title: "Apple로 로그인",
        font: UIFont.systemFont(ofSize: 19),
        backgroundColor: UIColor.normal_white)
    
    /// 이메일 로그인 버튼
    private lazy var emailLogin: UIButton = UIButton.btnWithTitle(
        title: "이메일로 로그인",
        font: UIFont.systemFont(ofSize: 19),
        backgroundColor: UIColor.normal_white)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: self.buttonArray,
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    // MARK: - 프로퍼티
    private lazy var buttonArray: [UIButton] = [self.appleLogin,
                                                self.emailLogin]
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
}

// MARK: - 화면 설정

extension SelectALoginMethodVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        // 버튼의 높이 설정 및 코너레디어스 설정
        self.buttonArray.forEach { btn in
            btn.snp.makeConstraints { make in
                make.height.equalTo(54)
            }
            
            
            // ********** UI설정 **********
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 10
        }
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.base_Blue
        // 네비게이션 타이틀 설정
        self.navigationItem.title = "로그인 선택"
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}
