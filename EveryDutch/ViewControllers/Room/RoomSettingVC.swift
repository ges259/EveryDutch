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
    
    
    private var tableView: SettlementDetailsTableView = SettlementDetailsTableView(customTableEnum: .isSegmentCtrl)
    
    /// 정산하기 버튼
    private var settleMoneyBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.deep_Blue)
    /// 정산 기록 버튼
    private var settlementDetailBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.deep_Blue)
    
    private lazy var settlementStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.settlementDetailBtn],
        axis: .horizontal,
        spacing: 4,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    private var tabBarView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    // 원형 버튼들
    private var exitBtn: UIButton = UIButton.configureCircleBtn(
        size: 11,
        title: "나가기",
        image: UIImage.Exit_Img)
    private var inviteBtn: UIButton = UIButton.configureCircleBtn(
        title: "초대",
        image: UIImage.Invite_Img)
    
    private var profileBtn: UIButton = UIButton.configureCircleBtn(
        title: "프로필",
        image: UIImage.person_Fill_Img)
    
    private lazy var roomSettingBtn: UIButton = UIButton.configureCircleBtn(
        title: "설정",
        image: UIImage.gear_Fill_Img)
    
    
    
    
    private lazy var btnStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [self.exitBtn,
                                                 self.inviteBtn,
                                                 self.profileBtn])
        stv.axis = .horizontal
        stv.alignment = .fill
        stv.distribution = .fillEqually
        return stv
    }()
    
    
    
    // MARK: - 프로퍼티
    private var coordinator: RoomSettingCoordinating?
    
    // (spaing X 2) + (leading + trailing)
//    private lazy var btnWidth: CGFloat = (self.view.frame.width - 90 - 40) / 3
    
    // ((버튼 크기 * 버튼 개수) - (leading + trailing)) / (버튼 개수 - 1)
    private lazy var btnWidth: CGFloat = (self.view.frame.width - 50 * 3 - 80) / 2
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: RoomSettingCoordinator) {
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
        [self.tableView,
         self.settleMoneyBtn,
         self.settlementDetailBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        
        self.tableView.topViewTableView.isScrollEnabled = false
        
        [self.exitBtn,
         self.inviteBtn,
         self.profileBtn].forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 50 / 2
        }
        self.tabBarView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        self.tabBarView.layer.cornerRadius = 15
        
        
        // MARK: - Fix
        self.settlementStackView.addArrangedSubview(self.settleMoneyBtn)
        // spacing
        self.btnStackView.spacing = self.btnWidth
        self.settleMoneyBtn.setTitle("정산하기", for: .normal)
        self.settlementDetailBtn.setTitle("정산 기록", for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.contentView)
        
        [self.tableView,
         self.settlementStackView].forEach { view in
            self.contentView.addSubview(view)
        }
        
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
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-UIDevice.current.topStackViewBottom)
        }
        self.settlementStackView.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom).offset(7)
            make.leading.trailing.equalTo(self.tableView)
            make.height.equalTo(45)
        }
        
        // For btnStackView
        self.btnStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
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
        let backButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
        
        self.settleMoneyBtn.addTarget(self, action: #selector(self.settleMoneyBtnTapped), for: .touchUpInside)
        
        
        self.inviteBtn.addTarget(self, action: #selector(self.inviteBtnTapped), for: .touchUpInside)
    }
    
    @objc private func inviteBtnTapped() {
        self.coordinator?.FindFriendsScreen()
    }
    @objc private func settleMoneyBtnTapped() {
        self.coordinator?.settlementScreen()
    }
    
    @objc private func backButtonTapped() {
        self.coordinator?.didFinish()
    }
}
