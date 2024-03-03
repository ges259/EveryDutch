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
    // 디테일 레이블
    private var detailLbl: CustomLabel = CustomLabel(
        leftInset: 20)
    // 텍스트 필드
    private lazy var textField: InsetTextField = {
        let tf = InsetTextField(
            backgroundColor: .normal_white,
            placeholerColor: .lightGray)
        tf.delegate = self
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    
    
    // MARK: - 프로퍼티
    private var cellType: EditCellType?
    weak var delegate: CardDataCellDelegate?
    
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
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.detailLbl)
        self.contentView.addSubview(self.textField)
        
        
        self.detailLbl.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(100)
        }
        self.textField.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(self.detailLbl.snp.trailing)
        }
    }
}








// MARK: - 함수

extension CardDataCell {
    
    // MARK: - 셀의 텍스트 설정
    func setDetailLbl(type: EditCellType?,
                      isFirst: Bool,
                      isLast: Bool)
    {
        
        guard let type = type else { return }
        self.cellType = type
        
        if isFirst { self.configureTextFieldCorner() }
        if isLast { self.configureLastCell() }
        
        self.detailLbl.text = type.getCellTitle
        
        self.textField.attributedPlaceholder = self.setAttributedText(
            placeholderText: type.getTextFieldPlaceholder)
        
    }
    
    // MARK: - 마지막 셀 모서리 설정
    private func configureLastCell() {
        self.setRoundedCorners(.bottom, withCornerRadius: 12)
    }
    
    // MARK: - 셀의 모서리 설정
    private func configureTextFieldCorner() {
        self.textField.setRoundedCorners(.leftTop, withCornerRadius: 12)
    }
}










// MARK: - 텍스트필드 델리게이트

extension CardDataCell: UITextFieldDelegate {
    
    // MARK: - 수정 시작
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
    }
    
    // MARK: - 수정 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        
        guard let cellType = self.cellType,
                let text = textField.text,
                text !=  "" else { return }
        
        self.delegate?.textData(type: cellType, text: text)
    }
}

protocol CardDataCellDelegate: AnyObject {
    func textData(type: EditCellType, text: String)
}
