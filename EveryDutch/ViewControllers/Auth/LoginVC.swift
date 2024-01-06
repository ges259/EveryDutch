//
//  LoginVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import UIKit
import SnapKit

final class LoginVC: UIViewController {
    
    // MARK: - 레이아웃
    private lazy var containerView: UIView = UIView.configureView(
        color: UIColor.medium_Blue)
    
    /// "로그인" 레이블
    private lazy var loginLbl: UILabel = UILabel.configureLbl(
        text: "이메일 로그인",
        font: UIFont.boldSystemFont(ofSize: 25))
    
    /// 이메일 텍스트필드
    private lazy var emailTF: InsetTextField = InsetTextField(
        placeholderText: "이메일을 입력하세요.",
        keyboardType: .emailAddress,
        keyboardReturnType: .continue)
    
    /// 비밀번호 텍스트필드
    private lazy var passwordTF: InsetTextField = InsetTextField(
        placeholderText: "비밀번호를 입력하세요.",
        keyboardType: .default,
        keyboardReturnType: .done)
    
    /// 로그인 버튼
    private lazy var logInBtn: UIButton = {
        let btn = UIButton.btnWithTitle(
            title: "로그인",
            titleColor: UIColor.white,
            font: UIFont.boldSystemFont(ofSize: 20),
            backgroundColor: UIColor.disableBtn)
            btn.isEnabled = false
        return btn
    }()
    
    /// 회원가입 화면으로 이동 버튼
    private lazy var goToSignUpViewBtn: UIButton = {
        let btn = UIButton.btnWithTitle(
            title: "아이디가 없으신가요?",
            font: UIFont.systemFont(ofSize: 13),
            backgroundColor: UIColor.clear)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.loginLbl,
                           self.emailTF,
                           self.passwordTF,
                           self.logInBtn],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    

    // MARK: - 프로퍼티
    private var coordinator: LoginScreenCoordProtocol?

    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: LoginScreenCoordProtocol) {
        self.coordinator =  coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension LoginVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
         self.view.backgroundColor = UIColor.base_Blue
         // 네비게이션 타이틀뷰(View) 설정
//         self.navigationItem.titleView = self.navTitle
//         self.navTitle.text = "로그인"
         // '아이디가 없으신가요?' 버튼 <- 스택뷰 간격 넓히기
         self.stackView.setCustomSpacing(15, after: self.loginLbl)
         
         [self.containerView,
          self.emailTF,
          self.passwordTF,
          self.logInBtn].forEach { view in
             view.clipsToBounds = true
             view.layer.cornerRadius = 10
         }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.goToSignUpViewBtn)
        
        // ********** 오토레이아웃 설정 **********
        // 컨테이너뷰
        self.containerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        //
        self.goToSignUpViewBtn.snp.makeConstraints { make in
            make.top.equalTo(self.stackView.snp.bottom).offset(10)
            make.leading.equalTo(self.stackView).offset(10)
            make.trailing.equalTo(self.stackView).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        // 텍스트필드 높이 설정
        [self.emailTF,
         self.passwordTF,
         self.logInBtn].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(45)
            }
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
//        self.logInBtn.addTarget(self, action: #selector(self.logInBtnTapped), for: .touchUpInside)
        self.goToSignUpViewBtn.addTarget(self, action: #selector(self.goToSignUpView), for: .touchUpInside)
//
//        [self.emailTF,
//         self.passwordTF].forEach { tf in
//            tf.addTarget(self, action: #selector(self.formValidation), for: .editingChanged)
//        }
        
        // 버튼 생성
        let backButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc private func goToSignUpView() {
        self.coordinator?.SignUpScreen()
    }
    @objc private func backButtonTapped() {
        self.coordinator?.didFinish()
    }
}
