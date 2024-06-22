//
//  RoomSettingVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit
import SnapKit

final class RoomSettingVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.bounces = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    // 탑뷰 내부 레이아웃
    private lazy var usersTableView: UsersTableView = {
        let view = UsersTableView(
            viewModel: UsersTableViewVM(
                roomDataManager: RoomDataManager.shared, .isRoomSetting))
            view.delegate = self
        return view
    }()
    
    
    
    private var tabBarView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    // 원형 버튼들
    private lazy var exitBtn: UIButton = UIButton.btnWithImg(
        image: .Exit_Img,
        imageSize: 12,
        imagePadding: 8,
        backgroundColor: UIColor.normal_white,
        title: "나가기",
        cornerRadius: self.btnSize)
    private lazy var inviteBtn: UIButton = UIButton.btnWithImg(
        image: .plus_Img,
        title: "초대",
        cornerRadius: self.btnSize)
    private lazy var roomSettingBtn: UIButton = UIButton.btnWithImg(
        image: .gear_Img,
        title: "설정",
        cornerRadius: self.btnSize)
    
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.exitBtn,
                           self.inviteBtn],
        axis: .horizontal,
        spacing: 16,
        alignment: .fill,
        distribution: .equalSpacing)
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: RoomSettingVMProtocol
    private var coordinator: RoomSettingCoordProtocol
    
    
    let btnSize: CGFloat = 60
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureClosure()
    }
    init(viewModel:RoomSettingVMProtocol,
         coordinator: RoomSettingCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정
extension RoomSettingVC {
    /// UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        self.tabBarView.setRoundedCorners(.top, withCornerRadius: 20)
        self.tabBarView.addShadow(shadowType: .top)
        
        if self.viewModel.checkIsRoomManager {
            self.btnStackView.addArrangedSubview(self.roomSettingBtn)
        }
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.usersTableView)
        self.view.addSubview(self.tabBarView)
        self.tabBarView.addSubview(self.btnStackView)
        
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(7)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        // 테이블뷰
        self.usersTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-UIDevice.current.topStackViewBottom)
        }
        // 하단 버튼 스택뷰를 담는 뷰
        self.tabBarView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
        // 하단 버튼 스택뷰
        self.btnStackView.snp.makeConstraints { make in
            self.configureBtnStackViewConstraints(
                make: make,
                numOfBtn: self.btnStackView.arrangedSubviews.count)
            
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
        // 하단 버튼의 넓이 및 높이 설정
        [self.exitBtn, self.inviteBtn, self.roomSettingBtn].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(self.btnSize)
            }
        }
    }
    
    /// 액션 설정
    private func configureAction() {
        // 뒤로가기 버튼 생성
        let backButton = UIBarButtonItem(
            image: .chevronLeft,
            style: .done,
            target: self,
            action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
        // 초대 버튼
        self.inviteBtn.addTarget(
            self,
            action: #selector(self.inviteBtnTapped),
            for: .touchUpInside)
        // 정산방 설정 버튼
        self.roomSettingBtn.addTarget(
            self,
            action: #selector(self.roomSettingBtnTapped),
            for: .touchUpInside)
        
        // 나가기 버튼
        self.exitBtn.addTarget(
            self,
            action: #selector(self.exitBtnBtnTapped),
            for: .touchUpInside)
    }
    
    private func configureClosure() {
        self.viewModel.successLeaveRoom = { [weak self] in
            guard let self = self else { return }
            self.coordinator.exitSuccess()
        }
        self.viewModel.errorClosure = { [weak self] errorType in
            guard let self = self else { return }
            switch errorType {
            case .unknownError,
                    .userRoomsIDDeleteError,
                    .roomUsersDeleteError:
                self.customAlert(alertEnum: errorType.alertType) { _ in }
                break
            default:
                break
            }
        }
    }
}










// MARK: - 버튼 액션 메서드
extension RoomSettingVC {
    // 뒤로가기 버튼 설정
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
    // 나가기 버튼
    @objc private func exitBtnBtnTapped() {
        
        
        
        // 얼럿창 띄우기
        self.customAlert(alertEnum: .exitRoom) { _ in
            // 확인 버튼을 누르면 -> 정산방에서 나가기
            self.viewModel.leaveRoom()
        }
    }
    // 유저 초대 화면으로 이동
    @objc private func inviteBtnTapped() {
        self.coordinator.FindFriendsScreen()
    }
    // 설정 화면으로 이동
    @objc private func roomSettingBtnTapped() {
        // roomManager라면
        if self.viewModel.checkIsRoomManager {
            // 방 설정 화면으로 이동
            let roomID = self.viewModel.getCurrentRoomID
            self.coordinator.roomEditScreen(DataRequiredWhenInEidtMode: roomID)
            
        } else {
            // 얼럿창
            self.customAlert(alertEnum: .isNotRoomManager) { _ in }
        }
    }
}

// MARK: - 테이블뷰 델리게이트
extension RoomSettingVC: UsersTableViewDelegate {
    func didSelectUser() {
        self.coordinator.userProfileScreen()
    }
}
