//
//  CardDataCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import UIKit
import SnapKit

final class CardDataCell: UITableViewCell {
    
    // MARK: - 레이아웃
    
    
    
    // MARK: - 프로퍼티
    // 디테일 레이블
    private var detailLbl: CustomLabel = CustomLabel(
        leftInset: 20)
    // 텍스트 필드
    var textField: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholerColor: .lightGray)
    
    // 스택뷰
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.detailLbl,
                           self.textField],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
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

extension CardDataCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.totalStackView)
        
        self.totalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.detailLbl.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
    }
    func setDetailLbl(text: String) {
        self.detailLbl.text = text
    }
}
