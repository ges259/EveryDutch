//
//  SignUpVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import UIKit

final class SignUpVC: UIViewController {
    
    // MARK: - 레이아웃
    private lazy var containerView: UIView = UIView.configureView(
        color: UIColor.medium_Blue)
    
    /// "로그인" 레이블
    private lazy var signUpLbl: CustomLabel = CustomLabel(
        text: "이메일 회원가입",
        font: UIFont.boldSystemFont(ofSize: 25))
    
    /// 이메일 텍스트필드
    private lazy var emailTF: InsetTextField = InsetTextField(
        placeholderText: "이메일을 입력하세요.",
        keyboardType: .emailAddress,
        keyboardReturnType: .continue)
    
    private lazy var userNameTF: InsetTextField = InsetTextField(
        placeholderText: "비밀번호를 입력하세요.",
        keyboardType: .default,
        keyboardReturnType: .continue)
    
    /// 비밀번호 텍스트필드
    private lazy var passwordTF: InsetTextField = InsetTextField(
        placeholderText: "비밀번호를 입력하세요.",
        keyboardType: .default,
        keyboardReturnType: .continue)
    
    private lazy var passwordCheckTF: InsetTextField = InsetTextField(
        placeholderText: "비밀번호를 입력하세요.",
        keyboardType: .default,
        keyboardReturnType: .done)
    

    
    /// 로그인 버튼
    private lazy var signUpBtn: UIButton = {
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
            title: "아이디가 이미 있으신가요?",
            font: UIFont.systemFont(ofSize: 13),
            backgroundColor: UIColor.clear)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.signUpLbl,
                           self.emailTF,
                           self.userNameTF,
                           self.passwordTF,
                           self.passwordCheckTF,
                           self.signUpBtn],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    
    // MARK: - 프로퍼티
    private var coordinator: SignUpScreenCoordProtocol?

    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: SignUpScreenCoordProtocol) {
        self.coordinator =  coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension SignUpVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.base_Blue
        
        self.stackView.setCustomSpacing(15, after: self.signUpLbl)
        
        [self.containerView,
         self.emailTF,
         self.userNameTF,
         self.passwordTF,
         self.passwordCheckTF,
         self.signUpBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        
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
            make.bottom.equalToSuperview().offset(-10)
        }
        // 텍스트필드 높이 설정
        [self.emailTF,
         self.userNameTF,
         self.passwordTF,
         self.passwordCheckTF,
         self.signUpBtn].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(45)
            }
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc private func backButtonTapped() {
        self.coordinator?.didFinish()
    }
}
