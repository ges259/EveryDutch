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
        font: UIFont.systemFont(ofSize: 14))
    
    lazy var receiptInfoLbl: PaddingLabel = PaddingLabel(
        font: UIFont.boldSystemFont(ofSize: 14),
        textAlignment: .right,
        leftRightInset: 10)
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.receiptImg,
                           self.receiptDetailLbl],
        axis: .horizontal,
        spacing: 8,
        alignment: .center,
        distribution: .fill)
    
    
    // MARK: - 프로퍼티
    private var receiptEnum: ReceiptEnum?
    private var infoLbl_IsHidden: Bool = false
    
    // MARK: - 라이프사이클
    init(receiptEnum: ReceiptEnum,
         infoLbl_IsHidden: Bool = false) {
        self.receiptEnum = receiptEnum
        self.infoLbl_IsHidden = infoLbl_IsHidden
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
        
        
        if !self.infoLbl_IsHidden {
            self.stackView.addArrangedSubview(self.receiptInfoLbl)
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        
        self.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.receiptImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        self.receiptDetailLbl.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}
