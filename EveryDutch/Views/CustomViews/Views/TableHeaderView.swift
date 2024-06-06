//
//  TableHeaderView.swift
//  EveryDutch
//
//  Created by 계은성 on 2/2/24.
//

import UIKit
import SnapKit

final class TableHeaderView: UIView {
    
    // MARK: - 레이아웃
    private lazy var titleLbl: CustomLabel = CustomLabel(
        textColor: UIColor.black,
        font: UIFont.boldSystemFont(ofSize: 25))
    
    
    
    
    
    // MARK: - 라이프 사이클
    init(title: String?,
         tableHeaderEnum: TableHeaderEnum) {
        super.init(frame: .zero)
        
        self.configureUI(title: title)
        self.configureBackgroundColor(tableHeaderEnum)
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 배경 색상 설정
    private func configureBackgroundColor(_ tableHeaderEnum: TableHeaderEnum) {
        self.backgroundColor = tableHeaderEnum.getBackgroundColor
    }
    
    // MARK: - 화면 설정
    private func configureUI(title: String?){
        self.titleLbl.text = title
        self.setRoundedCorners(.top, withCornerRadius: 10)
    }
    
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(titleLbl)
        self.titleLbl.snp.makeConstraints { make in
           make.leading.equalToSuperview().offset(20)
           make.centerY.equalToSuperview()
       }
    }
}
