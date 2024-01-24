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
    private lazy var memoCheckLbl: CustomLabel = CustomLabel(
        text: "✓  메모을 작성해 주세요",
        font: UIFont.systemFont(ofSize: 14))
    private lazy var priceCheckLbl: CustomLabel = CustomLabel(
        text: "✓  가격을 설정해 주세요",
        font: UIFont.systemFont(ofSize: 14))
    private lazy var payerCheckLbl: CustomLabel = CustomLabel(
        text: "✓  계산한 사람을 설정해 주세요.",
        font: UIFont.systemFont(ofSize: 14))
    private lazy var leftMoneyLbl: CustomLabel = CustomLabel(
        text: "✓  25,000원이 남았습니다.",
        font: UIFont.systemFont(ofSize: 14))
    private lazy var zeroWonLbl: CustomLabel = CustomLabel(
        text: "✓  0원으로 설정되어있는 사람이 있습니다.",
        font: UIFont.systemFont(ofSize: 14))
    private lazy var exceededMoneyLbl: CustomLabel = CustomLabel(
        text: "✓  금액이 초과되었습니다. 정확히 입력해 주세요.",
        font: UIFont.systemFont(ofSize: 14))
    
    
    private lazy var labelStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.memoCheckLbl,
                           self.priceCheckLbl,
                           self.payerCheckLbl,
                           self.leftMoneyLbl,
                           self.zeroWonLbl,
                           self.exceededMoneyLbl],
        axis: .vertical,
        spacing: 25,
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
        self.view.backgroundColor = UIColor.deep_Blue
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
        
        
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        self.labelStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.trailing.bottom.equalToSuperview().offset(-15)
        }
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
    // MARK: - 액션 설정
    private func configureViewWithValidation() {
        
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
