//
//  ReceiptDataCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/4/24.
//

import UIKit
import SnapKit

final class ReceiptScreenDataCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private lazy var cellStv: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: self.receiptEnum,
        addInfoLbl: true)
    
    
    // MARK: - 프로퍼티
    private var receiptEnum: ReceiptEnum = .time
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    // 설정 메서드 추가
    func configure(withReceiptEnum receiptEnum: ReceiptEnum) {
        self.receiptEnum = receiptEnum
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
}










// MARK: - 화면 설정

extension ReceiptScreenDataCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .normal_white
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.cellStv)
        self.cellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.cellStv.receiptInfoLbl.text = "fasdkllf;asdl"
    }
}
