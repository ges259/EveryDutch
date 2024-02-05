//
//  ReceiptWriteDataCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/4/24.
//

import UIKit
import SnapKit

final class ReceiptWriteDataCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private lazy var cellStv: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: self.receiptEnum)
    
    
    
    private lazy var textField: InsetTextField = {
        let tf = InsetTextField(
            backgroundColor: UIColor.normal_white,
            placeholderText: "메모를 입력해 주세요.",
            insetX: 25)
//        tf.delegate = self
        return tf
    }()
    
    private lazy var label: CustomLabel = CustomLabel(
        backgroundColor: UIColor.normal_white,
        leftInset: 25)
    
    
    private lazy var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0  / 12",
        font: UIFont.systemFont(ofSize: 13))
//    "0 / \(self.viewModel.TF_MAX_COUNT)"
    
    // MARK: - 프로퍼티
    private var receiptEnum: ReceiptEnum = .time
    
    
    // MARK: - 라이프사이클
    // 설정 메서드 추가
    func configure(withReceiptEnum receiptEnum: ReceiptEnum) {
        self.receiptEnum = receiptEnum
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureViewWithEnum()
    }
}

// MARK: - 화면 설정

extension ReceiptWriteDataCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.cellStv)
        self.cellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
        

    
    
    private func configureViewWithEnum() {
        switch self.receiptEnum {
        case .time, .payer:
            self.configureLabel()
            break
        case .price:
            self.configureTextField()
            break
            
        case .memo:
            self.configureTextField()
            self.configureNumOfCharLbl()
            break
        case .payment_Method, .date:
            break
        }
    }
    
    private func configureTextField() {
        self.addSubview(self.textField)
        
        self.textField.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    private func configureNumOfCharLbl() {
        self.addSubview(self.numOfCharLbl)
        // 글자 수 세는 레이블
        self.numOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureLabel() {
        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
}
