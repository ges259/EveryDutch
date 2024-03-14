//
//  FindFriendsVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/30.
//

import UIKit
import SnapKit

// MARK: - FindFriendsVC

final class FindFriendsVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 텍스트필드
    private var textField: InsetTextField = InsetTextField(
        backgroundColor: UIColor.clear,
        placeholderText: "친구 개인 ID")
    /// 글자 수 레이블
    private var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 8",
        font: UIFont.systemFont(ofSize: 13))
    /// 검색 버튼
    private var searchBtn: UIButton = UIButton.btnWithTitle(
        title: "검색",
        font: UIFont.systemFont(ofSize: 15),
        backgroundColor: UIColor.deep_Blue)
    /// 하단 선
    private var lineView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    /// 카드 이미지 뷰
    private var cardImgView: CardImageView = CardImageView()
    /// 하단 버튼
    private var inviteBottomBtn: BottomButton = BottomButton(
        title: "초대하기")
    /// 상단 스택뷰
    private lazy var topStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.textField,
                           self.numOfCharLbl,
                           self.searchBtn],
        axis: .horizontal,
        spacing: 20,
        alignment: .fill,
        distribution: .fill)
    
    private var noDataView: NoDataView = NoDataView(type: .findFriendsScreen)
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: FindFriendsVMProtocol
    private var coordinator: Coordinator
    
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureClosure()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: Coordinator,
         viewModel: FindFriendsVMProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension FindFriendsVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = .base_Blue
        self.searchBtn.setRoundedCorners(.all, withCornerRadius: 10)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.topStackView,
         self.lineView,
         self.cardImgView,
         self.inviteBottomBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        self.numOfCharLbl.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        self.searchBtn.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        self.topStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        self.lineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(self.topStackView.snp.bottom).offset(-2)
            make.leading.equalTo(self.topStackView).offset(10)
            make.trailing.equalTo(self.topStackView).offset(-20)
        }
        
        self.cardImgView.snp.makeConstraints { make in
            make.top.equalTo(self.topStackView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.topStackView)
            make.height.equalTo(self.cardHeight)
        }
        
        self.inviteBottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(
            image: .chevronLeft, 
            style: .done,
            target: self,
            action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
        
        // 하단 버튼 액션
        self.inviteBottomBtn.addTarget(
            self,
            action: #selector(self.inviteBottomBtnTapped),
            for: .touchUpInside)
        // 검색 버튼 액션
        self.searchBtn.addTarget(
            self,
            action: #selector(self.searchBtnTapped),
            for: .touchUpInside)
    }
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        self.viewModel.searchSuccessClosure = { [weak self] user in
            self?.configureCardImg(user: user)
        }
        
        self.viewModel.searchFailedClosure = { [weak self]  in
            self?.configureNoDataView()
        }
    }
    
    // MARK: - 카드 이미지 설정
    private func configureCardImg(user: User) {
        self.cardImgView.configureUserData(data: user)
    }
    
    // MARK: - NoData 뷰 설정
    private func configureNoDataView() {
        self.noDataView.configureUIWithType(type: .cantFindFriendScreen)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 뒤로가기 버튼 액션
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
    
    // MARK: - 검색 버튼
    @objc private func searchBtnTapped() {
        // 유저 검색
        self.viewModel.searchUser(text: self.textField.text)
    }
    
    // MARK: - 하단 버튼
    @objc private func inviteBottomBtnTapped() {
        
    }
}
