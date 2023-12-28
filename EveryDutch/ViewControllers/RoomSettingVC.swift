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
    private var segmentCtrl: CustomSegmentControl = CustomSegmentControl(
        items: ["누적 금액",
                "받아야 할 돈"])
    
    private var tableView: SettlementDetailsTableView = SettlementDetailsTableView()
    
    private var calculateBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.deep_Blue)
    
    private lazy var topStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.segmentCtrl,
                           self.tableView,
                           self.calculateBtn],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    
    
    // 원형 버튼들
    private var exitBtn: UIButton = UIButton.configureCircleBtn(
        title: "나가기",
        image: UIImage.Exit_Img)
    private var inviteBtn: UIButton = UIButton.configureCircleBtn(
        title: "초대하기",
        image: UIImage.Invite_Img)
    
    private var profileBtn: UIButton = UIButton.configureCircleBtn(
        title: "프로필",
        image: UIImage.person_Fill_Img)
    
    private var roomSettingBtn: UIButton = UIButton.configureCircleBtn(
        title: "방 설정",
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
    private lazy var btnWidth: CGFloat = (self.view.frame.width - 90 - 40) / 3
    
    
    
    
    
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
        
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 10
        
        self.calculateBtn.clipsToBounds = true
        self.calculateBtn.layer.cornerRadius = 10
        
        [self.exitBtn,
         self.inviteBtn,
         self.profileBtn].forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 43.8333
        }
        
        
        // spacing
        self.btnStackView.spacing = 45
        self.calculateBtn.setTitle("정산 기록 보기", for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.topStackView)
        self.view.addSubview(self.btnStackView)
        
        self.segmentCtrl.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        self.tableView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        self.calculateBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.topStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(7)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        // For btnStackView
        self.btnStackView.snp.makeConstraints { make in
            make.top.equalTo(self.topStackView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.exitBtn.snp.makeConstraints { make in
            make.height.equalTo(self.btnWidth)
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
        print(exitBtn.frame.width)
        print(exitBtn.frame.height)

        self.coordinator?.didFinish()
    }
}
