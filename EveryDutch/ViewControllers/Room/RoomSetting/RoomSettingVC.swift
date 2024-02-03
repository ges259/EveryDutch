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
    private var usersTableView: UsersTableView = UsersTableView(
        viewModel: UsersTableViewVM(
            roomDataManager: RoomDataManager.shared, .isRoomSetting))
    
    
    
    private var tabBarView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    // 원형 버튼들
    private var exitBtn: UIButton = UIButton.btnWithImg(
        image: .Exit_Img,
        imageSize: 11,
        backgroundColor: UIColor.normal_white,
        title: "나가기")
    private var inviteBtn: UIButton = UIButton.btnWithImg(
        image: .Invite_Img,
        imageSize: 15,
        backgroundColor: UIColor.normal_white,
        title: "초대")
    private lazy var roomSettingBtn: UIButton = UIButton.btnWithImg(
        image: .gear_Fill_Img,
        imageSize: 15,
        backgroundColor: UIColor.normal_white,
        title: "설정")
    
    private lazy var recordBtn: UIButton = UIButton.btnWithImg(
        image: .record_Img,
        imageSize: 15,
        backgroundColor: UIColor.normal_white,
        title: "기록")
            
    private lazy var settlementBtn: UIButton = UIButton.btnWithImg(
        image: .settlement_Img,
        imageSize: 15,
        backgroundColor: UIColor.normal_white,
        title: "정산")
    
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.exitBtn,
                           self.inviteBtn,
                           self.recordBtn,
                           self.settlementBtn,
                           self.roomSettingBtn],
        axis: .horizontal,
        spacing: self.btnStvSpacing,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    // MARK: - 프로퍼티
    private var viewModel: RoomSettingVMProtocol
    private var coordinator: RoomSettingCoordProtocol
    /**
        (화면 넓이
        - (버튼 크기 * 버튼 개수) -> (50 * 5) : 250
        - (leading + trailing)(20 + 20) : + 40
        ) 
        / (버튼 개수 - 1)(5 - 1) : / 4
     */
    private lazy var btnStvSpacing: CGFloat = (self.view.frame.width - 290) / 4
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureUserTableView()
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
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        self.usersTableView.usersTableView.isScrollEnabled = false
        
        [self.exitBtn,
         self.inviteBtn,
         self.roomSettingBtn,
         self.recordBtn,
         self.settlementBtn].forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 50 / 2
        }
        self.tabBarView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        self.tabBarView.layer.cornerRadius = 20
        self.tabBarView.addShadow(shadowType: .all)
        
    }
    
    // MARK: - 오토레이아웃 설정
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
        // For btnStackView
        self.btnStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
        
        self.exitBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.tabBarView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.tabBarHeight)
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
        
        self.settlementBtn.addTarget(
            self,
            action: #selector(self.settleMoneyBtnTapped),
            for: .touchUpInside)
        
        
        self.inviteBtn.addTarget(
            self, 
            action: #selector(self.inviteBtnTapped),
            for: .touchUpInside)
        self.roomSettingBtn.addTarget(
            self,
            action: #selector(self.roomSettingBtnTapped),
            for: .touchUpInside)
    }
    
    
    // MARK: - 테이블뷰 데이터 설정
    private func configureUserTableView() {
        self.usersTableView.viewModel.makeCellVM()
        self.usersTableView.usersTableView.reloadData()
    }
    
    
    
    
    
    
    @objc private func roomSettingBtnTapped() {
        self.coordinator.CardScreen()
    }
    @objc private func inviteBtnTapped() {
        self.coordinator.FindFriendsScreen()
    }
    @objc private func settleMoneyBtnTapped() {
        self.coordinator.settlementScreen()
    }
    
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
}
