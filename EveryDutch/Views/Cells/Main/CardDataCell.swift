//
//  CardDataCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/3/24.
//

import UIKit
import SnapKit

// MARK: - CardDataCellDelegate
protocol CardDataCellDelegate: AnyObject {
    func textData(cell: CardDataCell, type: EditCellType, text: String)
}



// MARK: - CardDataCell
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
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textField.layer.cornerRadius = 0
        self.layer.cornerRadius = 0
    }
}










// MARK: - 화면 설정
extension CardDataCell {
    /// UI 설정
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .medium_Blue
    }
    
    /// 오토레이아웃 설정
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
    func setDetailLbl(cellTuple: EditCellTypeTuple?,
                      isFirst: Bool,
                      isLast: Bool)
    {
        if isFirst { self.configureTextFieldCorner() }
        if isLast { self.configureLastCell() }
        
        guard let data = cellTuple else { return }
        let type = data.type
        // 현재 타입 저장
        self.cellType = type
        // 텍스트필드의 플레이스 홀더 설정
        self.textField.attributedPlaceholder = self.setAttributedText(
            placeholderText: type.getTextFieldPlaceholder)
        // 텍스트필드의 detail레이블 설정
        self.detailLbl.text = type.getCellTitle
        
        
        // detatil이 있다면
        if let text = data.detail,
           !text.isEmpty {
            self.textField.text = data.detail
            self.delegateTextData()
        }
    }
    
    // MARK: - 마지막 셀 모서리 설정
    private func configureLastCell() {
        self.setRoundedCorners(.bottom, withCornerRadius: 12)
    }
    
    // MARK: - 셀의 모서리 설정
    private func configureTextFieldCorner() {
        self.textField.setRoundedCorners(.leftTop, withCornerRadius: 12)
    }
    
    
    private func delegateTextData() {
        guard let cellType = self.cellType,
              let text = self.textField.text,
              !text.isEmpty
        else { return }
        // 텍스트필드가 빈칸이 아니라면, 델리게이트 전달
        self.delegate?.textData(cell: self,
                                type: cellType,
                                text: text)
    }
}










// MARK: - 텍스트필드 델리게이트
extension CardDataCell: UITextFieldDelegate {
    /// 수정 끝
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegateTextData()
    }
}
