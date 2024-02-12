//
//  CheckReceiptPanCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/11/24.
//

import UIKit
import SnapKit

final class CheckReceiptPanCell: UITableViewCell {
    
    // MARK: - 레이아웃
    var label: CustomLabel = CustomLabel(
        text: ReceiptCheck.memo.description,
        font: UIFont.systemFont(ofSize: 14))
    
    
    // MARK: - 프로퍼티
    
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





// MARK: - 화면 설정

extension CheckReceiptPanCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .normal_white
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.label)
        
        self.label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.trailing.bottom.equalToSuperview().offset(-15)
        }
    }
}
