//
//  ReceiptStackView.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit
import SnapKit

final class ReceiptStackView: UIView {
    // MARK: - 레이아웃
    private var receiptImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    private var receiptDetailLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 15))
    
    var receiptInfoLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 15))
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.receiptImg,
                           self.receiptDetailLbl,
                           self.receiptInfoLbl],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    
    // MARK: - 프로퍼티
    private var receiptEnum: ReceiptEnum?
    
    
    // MARK: - 라이프사이클
    init(receiptEnum: ReceiptEnum) {
        self.receiptEnum = receiptEnum
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 화면 설정

extension ReceiptStackView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.receiptImg.image = self.receiptEnum?.img
        self.receiptDetailLbl.text = self.receiptEnum?.text
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        
        self.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        self.receiptImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        self.receiptDetailLbl.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}
