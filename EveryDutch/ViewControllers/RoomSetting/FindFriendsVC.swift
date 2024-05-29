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
    private lazy var textField: CustomTextField = CustomTextField(
        TF_MAX_COUNT: 8,
        placeholder: "친구 개인 ID로 검색")
    
    
    
    
    
    /// 검색 버튼
    private var searchBtn: UIButton = {
        let btn = UIButton.btnWithTitle(
            title: "검색",
            font: UIFont.systemFont(ofSize: 15),
            backgroundColor: UIColor.deep_Blue)
        btn.setRoundedCorners(.all, withCornerRadius: 10)
        return btn
    }()
        
    /// 하단 선
    private var lineView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    /// 카드 이미지 뷰
    private var cardImgView: CardImageView = {
        let view = CardImageView()
        view.isHidden = true
        return view
    }()
    /// NoData뷰
    private var noDataView: NoDataView = {
        let view = NoDataView(type: .findFriendsScreen)
        view.setRoundedCorners(.all, withCornerRadius: 10)
        return view
    }()
    /// 상단 스택뷰
    private lazy var topStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.textField,
                           self.searchBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.topStackView,
                           self.noDataView,
                           self.cardImgView],
        axis: .vertical,
        spacing: 15,
        alignment: .fill,
        distribution: .fill)
    
    
    
    /// 하단 버튼
    private var inviteBottomBtn: BottomButton = BottomButton(
        title: "초대하기")
    
    
    
    
    
    
    
    
    
    
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
    /// UI 설정
    private func configureUI() {
        self.view.backgroundColor = .base_Blue
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.totalStackView,
         self.lineView,
         self.inviteBottomBtn].forEach { view in
            self.view.addSubview(view)
        }
        // 검색 버튼
        self.searchBtn.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        // 검색 하단 버튼
        self.lineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(self.totalStackView.snp.top).offset(38)
            make.leading.equalTo(self.totalStackView)
            make.trailing.equalTo(self.totalStackView).offset(-20)
        }
        // 상단 스택뷰
        self.topStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        // 전체 스택뷰
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight)
        }
        // Nodata뷰
        self.noDataView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight * 1.5)
        }
        // 하단 버튼
        self.inviteBottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
    }
    
    /// 액션 설정
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
    
    /// 클로저 설정
    private func configureClosure() {
        // 검색 성공
        self.viewModel.searchSuccessClosure = { [weak self] user in
            self?.configureCardImg(user: user)
        }
        // 초대 성공
        self.viewModel.inviteSuccessClosure = { [weak self]  in
            self?.inviteSuccess()
        }
        // 에러
        self.viewModel.apiErrorClosure = { [weak self] errorType in
            self?.handleApiError(errorType)
        }
    }
}






    
    


// MARK: - 클로저 함수
extension FindFriendsVC {
    /// 에러 작업
    private func handleApiError(_ error: ErrorEnum) {
        // noDataView 화면에 띄우기
        self.configureNoDataView()
        
        // 얼럿창 설정
        switch error {
        case .searchFailed, .userNotFound:
            break
        case .searchIdError,
                .invalidCharacters,
                .containsWhitespace,
                .userAlreadyExists,
                .roomDataError,
                .roomUserUpdateFailed,
                .roomUserIDUpdateFailed,
                .unknownError:
            // 얼럿창 띄우기
            self.customAlert(alertStyle: .alert,
                             alertEnum: error.alertType) { _ in return }
            break
        default:
            break
        }
    }
    /// 에러 클로저 - NoData 뷰 설정
    private func configureNoDataView() {
        // noDataView 화면에 띄우기
        self.noDataView.configureUIWithType(type: .cantFindFriendScreen)
        // 카드 이미지 숨기기
        self.cardImgViewIsHidden(true)
    }
    
    /// api작업 성공 시
    private func inviteSuccess() {
        self.customAlert(alertStyle: .alert,
                         alertEnum: .inviteSuccess) { _ in return }
    }
    
    /// 카드 이미지 설정
    private func configureCardImg(user: User) {
        // 카드 이미지뷰 설정
        self.cardImgView.setupUserData(data: user)
        // 카드 이미지 보이게 하기
        self.cardImgViewIsHidden(false)
    }
    
    /// 카드 이미지뷰를 숨길지 결정하는 메서드
    private func cardImgViewIsHidden(_ isHidden: Bool) {
        // 정상적으로 적용
        self.cardImgView.isHidden = isHidden
        // 반대로 적용
        self.noDataView.isHidden = !isHidden
        
        // 반대로 적용
        self.inviteBottomBtn.isEnabled = !isHidden
        let color: UIColor = isHidden ? .medium_Blue : .deep_Blue
        self.inviteBottomBtn.backgroundColor = color
    }
}
    
    
    
    
    
    
    
    


// MARK: - 버튼 액션 함수
extension FindFriendsVC {
    /// 뒤로가기 버튼 액션
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
    
    /// 검색 버튼
    @objc private func searchBtnTapped() {
        let currentText = self.textField.currentText
        // 유저 검색
        self.viewModel.searchUser(text: currentText)
    }
    
    /// 하단 버튼
    @objc private func inviteBottomBtnTapped() {
        self.viewModel.inviteUser()
    }
}
