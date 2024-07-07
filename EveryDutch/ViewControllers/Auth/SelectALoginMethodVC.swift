//
//  SelectALoginMethodVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/02.
//

import UIKit
import SnapKit

final class SelectALoginMethodVC: UIViewController {
    
    // MARK: - 아이콘 뷰
    private var iconBackgroundView: UIView = UIView.configureView(
        color: UIColor.clear)
    
    // MARK: - 아이콘 이미지
    // 앱 아이콘
    private var iconImg: UIImageView = {
        let img = UIImageView(image: UIImage.Exit_Img)
        img.backgroundColor = .normal_white
        return img
    }()
    
    // MARK: - 아이콘 레이블
    private var iconLbl: CustomLabel = CustomLabel(
        text: "더치더치 계정을 만들어보세요!",
        font: UIFont.boldSystemFont(ofSize: 19),
        textAlignment: .center)
    
    
    // MARK: - 로그인 버튼
    /// 애플 로그인 버튼
    private lazy var anonymousLoginBtn: UIButton = UIButton.btnWithTitle(
        title: "익명으로 로그인",
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.normal_white)
    
    /// 애플 로그인 버튼
    private lazy var appleLoginBtn: UIButton = UIButton.btnWithTitle(
        title: "Apple로 로그인",
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.normal_white)
    
    // MARK: - 버튼 스택뷰
    /// 스택뷰
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: self.buttonArray,
        axis: .vertical,
        spacing: 6,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: SelectALoginMethodVMProtocol
    private var coordinator: SelectALoginMethodCoordProtocol
    
    
    private lazy var buttonArray: [UIButton] = [
        self.anonymousLoginBtn,
        self.appleLoginBtn]
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: SelectALoginMethodVMProtocol,
         coordinator: SelectALoginMethodCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator =  coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("\(#function)-----\(self)")
    }
}










// MARK: - 화면 설정

extension SelectALoginMethodVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.base_Blue
        
        // 네비게이션 타이틀 설정
        
        
        
        // 모서리 설정
        self.iconImg.clipsToBounds = true
        self.iconImg.layer.cornerRadius = 190 / 2
        
        self.iconBackgroundView.clipsToBounds = true
        self.iconBackgroundView.layer.cornerRadius = 10
        // 버튼들의 모서리 설정
        self.buttonArray.forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.btnStackView)
        self.view.addSubview(self.iconBackgroundView)
        self.iconBackgroundView.addSubview(self.iconImg)
        self.iconBackgroundView.addSubview(self.iconLbl)
        
        // ********** 오토레이아웃 설정 **********
        // 스택뷰
        self.btnStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-19)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        // 버튼의 높이 설정
        self.anonymousLoginBtn.snp.makeConstraints { make in
            make.height.equalTo(53)
        }
        self.iconBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalTo(self.btnStackView)
            make.bottom.equalTo(self.btnStackView.snp.top).offset(-10)
        }
        self.iconImg.snp.makeConstraints { make in
            make.width.height.equalTo(190)
            make.centerX.centerY.equalToSuperview()
        }
        self.iconLbl.snp.makeConstraints { make in
            make.top.equalTo(self.iconImg.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        // 로그인에 성공했을 때,
//        self.viewModel.singInSuccessClosure = { [weak self] in
//            self?.goToMainVC()
//        }
//        // 로그인에 실패했을 때,
//        self.viewModel.singInFailClosure = { [weak self] in
//            self?.upAlert()
//        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.anonymousLoginBtn.addTarget(
            self,
            action: #selector(self.anonymousLoginBtnTapped),
            for: .touchUpInside)
        
        self.appleLoginBtn.addTarget(
            self,
            action: #selector(self.appleLoginBtnTapped),
            for: .touchUpInside)
    }
    
    
    
    
    
    // MARK: - MainVC로 화면 이동
    private func signInSuccess() {
        
        
        // MARK: - Fix - ProviderTuple
        self.coordinator.mainToMakeUser()
    }
    
    // MARK: - 얼럿창 띄우기
    private func signInFail() {
        
    }
}
    
    
    
    
    
    




// MARK: - 버튼 액션 메서드

extension SelectALoginMethodVC {
    
    // MARK: - 익명 로그인 버튼
    @objc private func anonymousLoginBtnTapped() {
        self.viewModel.signInAnonymously { [weak self] result in
            switch result {
            case .success():
                self?.signInSuccess()
                break
                
            case .failure(_):
                self?.signInFail()
                break
            }
        }
    }
    
    // MARK: - 애플 로그인 버튼
    @objc private func appleLoginBtnTapped() {
        
    }
}
