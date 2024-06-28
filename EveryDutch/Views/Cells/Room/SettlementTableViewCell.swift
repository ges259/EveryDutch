//
//  SettlementTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit
import SnapKit

final class ReceiptTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private lazy var baseView: UIView = UIView.configureView(
        color: UIColor.normal_white)
    
    private var contextLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 15))
    private var priceLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14),
        textAlignment: .right)
    private var timeLbl: CustomLabel = CustomLabel(
        textColor: .gray,
        font: UIFont.systemFont(ofSize: 12))
    private var allPayerLbl: CustomLabel = CustomLabel(
        textColor: .gray,
        font: UIFont.systemFont(ofSize: 12),
        textAlignment: .right)
    
    
    private lazy var topStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.contextLbl, 
                           self.priceLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var bottomStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.timeLbl, 
                           self.allPayerLbl],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    
    
    // MARK: - 프로퍼티
    
    var viewModel: ReceiptTableViewCellVMProtocol?
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, 
                   reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contextLbl.text = ""
        self.allPayerLbl.text = ""
        self.priceLbl.text = ""
        self.timeLbl.text = ""
        self.setRoundedCorners(.all, withCornerRadius: 0)
    }
}










// MARK: - 화면 설정
extension ReceiptTableViewCell {
    /// UI 설정
    private func configureUI() {
        self.baseView.layer.cornerRadius = 8
        self.baseView.clipsToBounds = true
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.baseView)
        self.baseView.addSubview(self.topStackView)
        self.baseView.addSubview(self.bottomStackView)
        
        self.baseView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
        self.topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        self.bottomStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}



// MARK: - 데이터 설정
extension ReceiptTableViewCell {

    func configureCell(
        with viewModel: ReceiptTableViewCellVMProtocol?,
        isFirst: Bool,
        isLast: Bool
    ) {
        // 모서리 설정
        var cornerRoundType: CornerRoundType = .all
        if isFirst && isLast    { cornerRoundType = .all    }
        else if isFirst         { cornerRoundType = .bottom }
        else if isLast          { cornerRoundType = .top    }
        self.setRoundedCorners(cornerRoundType, withCornerRadius: 10)
        
        
        // 뷰모델 저장
        self.viewModel = viewModel
        
        // viewModel을 사용하여 셀의 뷰를 업데이트.
        if let viewModel = viewModel {
            let receipt = viewModel.getReceipt
            self.contextLbl.text = receipt.context
            self.allPayerLbl.text = receipt.payerName
            self.priceLbl.text = "\(receipt.price)"
            self.timeLbl.text = receipt.time
        }
    }
}
