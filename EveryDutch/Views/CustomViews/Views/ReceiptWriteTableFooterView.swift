//
//  ReceiptWriteTableFooterView.swift
//  EveryDutch
//
//  Created by 계은성 on 5/5/24.
//

import UIKit
import SnapKit

protocol ReceiptWriteTableFooterViewDelegate: AnyObject {
    func dutchBtnTapped()
}

final class ReceiptWriteTableFooterView: UIView {
    
    // MARK: - 레이아웃
    private var moneyCountLbl: CustomLabel = CustomLabel(
        text: "0원",
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    private var dutchBtn: UIButton = UIButton.btnWithTitle(
        title: "1 / n",
        font: UIFont.systemFont(ofSize: 13),
        backgroundColor: UIColor.normal_white)
    
    private lazy var tableDutchFooterStv: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.moneyCountLbl,
                           self.dutchBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    private var noDataView: NoDataView = NoDataView(type: .ReceiptWriteScreen)
    
    private lazy var tableFooterTotalStv: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.noDataView,
                           self.tableDutchFooterStv],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    weak var delegate: ReceiptWriteTableFooterViewDelegate?
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.tableDutchFooterStv.setRoundedCorners(.bottom, withCornerRadius: 10)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.tableFooterTotalStv)
        self.tableFooterTotalStv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - 액션 설정
    private func configureAction() {
        // 더치 버튼
        self.dutchBtn.addTarget(
            self,
            action: #selector(self.dutchBtnTapped),
            for: .touchUpInside)
    }
    
    
    
    // MARK: - 액션
    @objc private func dutchBtnTapped() {
        self.delegate?.dutchBtnTapped()
    }
    func setMoneyCountLabel(totalPrice: String?) {
        self.moneyCountLbl.text = totalPrice
    }
    func updateView(nodataViewIsHidden: Bool, ductchBtnColor: UIColor) {
        self.noDataView.isHidden = nodataViewIsHidden
        self.dutchBtn.backgroundColor = ductchBtnColor
        // 스택 뷰의 레이아웃을 즉시 업데이트
        self.tableFooterTotalStv.layoutIfNeeded()
    }
}

