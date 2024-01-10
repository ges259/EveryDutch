//
//  ReceiptBtnStackView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/11/24.
//

import UIKit

final class ReceiptBtnStackView: UIStackView {
    // MARK: - 레이아웃
    private var firstBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.normal_white)

    private var secondBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.unselected_gray)
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureUI() {
        
    }
    
    private func configureAutoLayout() {
        
    }
}


