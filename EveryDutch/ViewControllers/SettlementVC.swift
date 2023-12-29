//
//  SettlementVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/28.
//

import UIKit
import SnapKit

final class SettlementVC: UIViewController {
    
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
    
    private var settlementNameLbl: UILabel = UILabel.configureLbl(
        text: "이름 설정",
        font: UIFont.systemFont(ofSize: 15),
        backgroundColor: .medium_Blue,
        textAlignment: .center)
    
    private var textField: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholerColor: .lightGray,
        placeholderText: "안녕하세요.")
    
    private lazy var numOfCharLbl: UILabel = UILabel.configureLbl(
        text: "0 / 10",
        font: UIFont.systemFont(ofSize: 13))
    
    
    private var tableView: SettlementDetailsTableView = SettlementDetailsTableView()
    
    private var settlementBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 22),
        backgroundColor: .deep_Blue)
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.settlementNameLbl,
                           self.textField,
                           self.tableView],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    
    // MARK: - 프로퍼티
    var coordinator: SettlementCoordinating?
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: SettlementCoordinating) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension SettlementVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = .base_Blue
        
        self.settlementNameLbl.clipsToBounds = true
        self.settlementNameLbl.layer.cornerRadius = 10
        
        self.settlementBtn.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        self.settlementBtn.layer.cornerRadius = 35
        self.tableView.topViewTableView.isScrollEnabled = false
        
        // MARK: - Fix
        self.settlementBtn.setTitle("정산하기", for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.stackView)
        self.textField.addSubview(self.numOfCharLbl)

        self.view.addSubview(self.settlementBtn)
        
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
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            // 아래의 bottom 제약조건은 중요합니다. 이것이 컨텐트뷰의 실제 높이를 결정합니다.
            make.bottom.equalToSuperview().offset(-UIDevice.current.bottomBtnHeight - 7)
        }
        self.settlementBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
        }
        self.settlementNameLbl.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        self.textField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        self.numOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-7)
            make.centerY.equalToSuperview()
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
