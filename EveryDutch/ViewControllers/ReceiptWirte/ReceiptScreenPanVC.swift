//
//  ReceiptScreenPanVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/03.
//

import UIKit
import SnapKit
import PanModal

final class ReceiptScreenPanVC: UIViewController {
    // MARK: - 레이아웃
    private var topLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 15),
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    private var whiteVeiw: UIView = UIView.configureView(
        color: UIColor.normal_white)
    
    // 스택뷰
    private var memoStackView: ReceiptStackView = ReceiptStackView(
        receiptEnum: .memo)
    private var dateStackView: ReceiptStackView = ReceiptStackView(
        receiptEnum: .date)
    private var timeStackView: ReceiptStackView = ReceiptStackView(
        receiptEnum: .time)
    private var priceStackView: ReceiptStackView = ReceiptStackView(
        receiptEnum: .price)
    private var payerStackVeiw: ReceiptStackView = ReceiptStackView(
        receiptEnum: .payer)
    private var paymentMethodStackView: ReceiptStackView = ReceiptStackView(
        receiptEnum: .payment_Method)
    
    
    // 테이블뷰
    private var tableView: SettlementDetailsTableView = SettlementDetailsTableView(customTableEnum: .isLbl)
    
    // 하단 버튼
    private lazy var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 17),
        backgroundColor: UIColor.normal_white)
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.topLbl,
                           self.whiteVeiw,
                           self.tableView],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var receiptStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.memoStackView,
                           self.dateStackView,
                           self.timeStackView,
                           self.priceStackView,
                           self.payerStackVeiw,
                           self.paymentMethodStackView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    // MARK: - 프로퍼티
    var coordinator: Coordinator?
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.didFinish()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension ReceiptScreenPanVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.deep_Blue
        
        self.topLbl.clipsToBounds = true
        self.topLbl.layer.cornerRadius = 10
        self.whiteVeiw.clipsToBounds = true
        self.whiteVeiw.layer.cornerRadius = 10
        // MARK: - Fix
        self.topLbl.text = "영수증"
        
        
        self.memoStackView.receiptInfoLbl.text = "맥도날드"
        self.dateStackView.receiptInfoLbl.text = "2023.12.14"
        self.timeStackView.receiptInfoLbl.text = "00 : 23"
        self.priceStackView.receiptInfoLbl.text = "12,000원"
        self.payerStackVeiw.receiptInfoLbl.text = "노주영"
        self.paymentMethodStackView.receiptInfoLbl.text = "1 / N"
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.totalStackView)
        self.whiteVeiw.addSubview(self.receiptStackView)
        
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(UIDevice.current.panBottomAnchor)
        }
        self.receiptStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        self.memoStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}



// MARK: - 팬모달 설정
extension ReceiptScreenPanVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        return .contentHeight(self.totalStackView.frame.height + -UIDevice.current.panBottomAnchor + 15)
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
