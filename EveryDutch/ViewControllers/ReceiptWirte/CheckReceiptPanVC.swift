//
//  CheckReceiptPanVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/03.
//

import UIKit
import SnapKit
import PanModal

final class CheckReceiptPanVC: UIViewController {
    // MARK: - 레이아웃
    
    private var topLbl: CustomLabel = CustomLabel(
        text: "아직 체크되지 않은 부분이 있어요",
        font: UIFont.boldSystemFont(ofSize: 15),
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    private var whiteView: UIView = UIView.configureView(
        color: UIColor.normal_white)
    
    private var bottomBtn: UIButton = UIButton.btnWithTitle(
        title: "확인",
        font: UIFont.boldSystemFont(ofSize: 16),
        backgroundColor: UIColor.normal_white)
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.topLbl,
                           self.whiteView,
                           self.bottomBtn],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    // 레이블
    private var memoCheckLbl: CustomLabel = CustomLabel(
        text: ReceiptCheck.memo.description,
        font: UIFont.systemFont(ofSize: 14))
    private var priceCheckLbl: CustomLabel = CustomLabel(
        text: ReceiptCheck.price.description,
        font: UIFont.systemFont(ofSize: 14))
    private var payerCheckLbl: CustomLabel = CustomLabel(
        text: ReceiptCheck.payer.description,
        font: UIFont.systemFont(ofSize: 14))
    private var noUsersLbl: CustomLabel = CustomLabel(
        text: ReceiptCheck.selectedUsers.description,
        font: UIFont.systemFont(ofSize: 14))
    private var zeroWonLbl: CustomLabel = CustomLabel(
        text: ReceiptCheck.usersPriceZero.description,
        font: UIFont.systemFont(ofSize: 14))
    private var cumulativeMoneyLbl: CustomLabel = CustomLabel(
        text: ReceiptCheck.cumulativeMoney.description,
        font: UIFont.systemFont(ofSize: 14))
    
    
    private lazy var labelStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.memoCheckLbl,
                           self.priceCheckLbl,
                           self.payerCheckLbl,
                           self.noUsersLbl,
                           self.zeroWonLbl,
                           self.cumulativeMoneyLbl],
        axis: .vertical,
        spacing: 23,
        alignment: .fill,
        distribution: .fillEqually)
    
    // MARK: - 프로퍼티
    var coordinator: Coordinator
    private var validationDict = [String: Bool]()
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureViewWithValidation()
    }
    init(coordinator: Coordinator,
         validationDict: [String: Bool]) {
        self.coordinator = coordinator
        self.validationDict = validationDict
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator.didFinish()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension CheckReceiptPanVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.deep_Blue
        // 모서리 설정
        [self.topLbl,
         self.whiteView,
         self.bottomBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.totalStackView)
        self.whiteView.addSubview(self.labelStackView)
        
        // 전체 스택뷰 (상단 레이블, 레이블 스택뷰, 하단 버튼)
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        // 레이블들의 스택뷰
        self.labelStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.trailing.bottom.equalToSuperview().offset(-15)
        }
        // 상단 레이블
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        // 하단 버튼
        self.bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
    // MARK: - 레이블 스택뷰 설정
    private func configureViewWithValidation() {
        // 레이블과 해당 ReceiptCheck를 연결
        let labelValidationPairs: [(label: UILabel, check: ReceiptCheck)] = [
            (self.memoCheckLbl, .memo),
            (self.payerCheckLbl, .payer),
            (self.priceCheckLbl, .price),
            (self.noUsersLbl, .selectedUsers),
            (self.zeroWonLbl, .usersPriceZero),
            (self.cumulativeMoneyLbl, .cumulativeMoney)
        ]
        
        // 각 레이블의 숨김 여부를 설정
        for (label, check) in labelValidationPairs {
            label.isHidden = self.validationDict[check.rawValue] ?? true
        }
    }
}




// MARK: - 팬모달 설정
extension CheckReceiptPanVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        return .contentHeight(self.totalStackView.frame.height + 10 + 15)
    }
    /// 화면 밖 - 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    /// 상단 인디케이터 없애기
    var showDragIndicator: Bool {
        return false
    }
    var cornerRadius: CGFloat {
        return 23
    }
}
