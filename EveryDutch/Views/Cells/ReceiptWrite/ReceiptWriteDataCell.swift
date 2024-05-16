//
//  ReceiptWriteDataCell.swift
//  EveryDutch
//
//  Created by 계은성 on 2/4/24.
//

import UIKit
import SnapKit

final class ReceiptWriteDataCell: UITableViewCell {
    
    // MARK: - 스택뷰
    private lazy var cellStv: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: self.viewModel?.getReceiptEnum ?? .time)
    
    // MARK: - 텍스트필드
    private lazy var textField: InsetTextField = {
        let tf = InsetTextField(
            backgroundColor: UIColor.normal_white,
            insetX: 25)
        tf.delegate = self
        return tf
    }()
    
    // MARK: - 레이블
    private lazy var label: CustomLabel = CustomLabel(
        backgroundColor: UIColor.normal_white,
        leftInset: 25)
    
    // MARK: - 글자 수 레이블
    private lazy var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / \(self.viewModel?.TF_MAX_COUNT ?? 12)",
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: ReceiptWriteDataCellDelegate?
    private var viewModel: ReceiptWriteDataCellVMProtocol?
    
    
    
    
    
    // MARK: - 라이프사이클
    func configureCell(viewModel: ReceiptWriteDataCellVMProtocol?) {
        self.viewModel = viewModel
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureViewWithEnum()
    }
}










// MARK: - Helper_Functions

extension ReceiptWriteDataCell {
    
    // MARK: - 레이블 텍스트 설정
    func setLabelText(text: String?) {
        self.label.textColor = UIColor.black
        self.label.text = text
    }
    
    // MARK: - 날짜 텍스트 설정
    func setDateString(date: Date) {
        self.configureDateString(date: date)
    }
}










// MARK: - 화면 설정

extension ReceiptWriteDataCell {
    
    // MARK: - Enum에 따른 설정
    private func configureViewWithEnum() {
        guard let receiptEnum = self.viewModel?.getReceiptEnum else { return }
        
        switch receiptEnum {
        case .date:     self.configureDateUI()
        case .time:     self.configureTimeUI()
        case .payer:    self.configurePayerUI()
        case .price:    self.configurePriceUI()
        case .memo:     self.configureMemoUI()
        case .payment_Method: break
        }
    }
    
    // MARK: - 날짜
    private func configureDateUI() {
        self.configureLabelAutoLayout()
        self.configureLabelAction()
        self.configureDateString()
    }
    
    // MARK: - 시간
    private func configureTimeUI() {
        self.configureLabelAutoLayout()
        self.configureLabelAction()
        self.configureTimeEnumUI()
    }
    
    // MARK: - Payer
    private func configurePayerUI() {
        self.configureLabelAutoLayout()
        self.configureLabelAction()

        self.configurePayerEnumUI()
    }
    
    // MARK: - 가격
    private func configurePriceUI() {
        self.configureTextFieldAutoLayout()
        self.configureTextFieldAction()
        self.configurePriceEnumUI()
    }
    
    // MARK: - 메모
    private func configureMemoUI() {
        self.configureTextFieldAutoLayout()
        self.configureNumOfCharLbl()
        self.configureTextFieldAction()
        self.textField.setPlaceholderText(
            text: "메모을 입력해 주세요.")
    }
}




    
    
    
    
    

// MARK: - UI 설정

extension ReceiptWriteDataCell {
    
    // MARK: - [공통]
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .normal_white
        
        self.cellStv.backgroundColor = .medium_Blue
    }
    
    
    
    
    
    // MARK: - 첫 번째 셀
    func configureFirstCell() {
        // 스택뷰의 모서리 설정
        self.cellStv.setRoundedCorners(.rightTop, withCornerRadius: 10)
    }
    
    // MARK: - 마지막 셀
    func configureLastCell() {
        // 스택뷰의 모서리 설정
        self.cellStv.setRoundedCorners(.rightBottom, withCornerRadius: 10)
        // 셀의 모서리 설정
        self.setRoundedCorners(.bottom, withCornerRadius: 10)
    }
    
    
    
    
    
    // MARK: - 날짜
    private func configureDateString(date: Date = Date()) {
        self.label.text = Date.returnYearString(date: date)
    }
    
    // MARK: - 시간
    private func configureTimeEnumUI() {
        // 레이블 텍스트 설정
        self.label.text = self.viewModel?.getCurrentTime()
    }
    
    // MARK: - payer
    private func configurePayerEnumUI() {
        self.label.attributedText = NSAttributedString.configure(
            text: "계산한 사람을 설정해 주세요.",
            color: UIColor.placeholder_gray, 
            font: UIFont.systemFont(ofSize: 13))
    }
    
    // MARK: - 가격
    private func configurePriceEnumUI() {
        self.textField.setPlaceholderText(
            text: "가격을 입력해 주세요.")
        self.textField.keyboardType = .numberPad
    }
}




    
    
    
    
    
    
// MARK: - [오토레이아웃]

extension ReceiptWriteDataCell {
    
    // MARK: - [공통]
    private func configureAutoLayout() {
        self.addSubview(self.cellStv)
        self.cellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 텍스트필드
    private func configureTextFieldAutoLayout() {
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 글자 수
    private func configureNumOfCharLbl() {
        self.addSubview(self.numOfCharLbl)
        // 글자 수 세는 레이블
        self.numOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 레이블
    private func configureLabelAutoLayout() {
        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
}



    
    
    
    
    
    
    
// MARK: - [액션 설정]

extension ReceiptWriteDataCell {
    
    private func configureLabelAction() {
        // '계산한 사람' 레이블 제스처 생성
        let dateGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.labelTapped))
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(dateGesture)
    }

    
    private func configureTextFieldAction() {
        self.textField.addTarget(
            self,
            action: #selector(self.textFieldIsChanged),
            for: .editingChanged)
    }
}
    
    
    
    
    
    
    
    
    
    
// MARK: - [액션]

extension ReceiptWriteDataCell {
    @objc private func labelTapped() {
        self.delegate?.cellIsTapped(self, type: self.viewModel?.getReceiptEnum)
    }
    
    
    
    
    
    @objc private func textFieldIsChanged() {
        guard let type = self.viewModel?.getReceiptEnum else { return }
        
        switch type {
        case .memo:
            self.memoInfoTFDidChanged()
        case .price:
            self.priceInfoTFDidChanged()
        default: break
        }
    }
    
    
    // MARK: - 가격 텍스트필드
    private func priceInfoTFDidChanged() {
        guard let currentText = self.textField.text else { return }

        // 포매팅된 문자열로 텍스트 필드 업데이트
        self.textField.text = self.viewModel?.formatPriceForEditing(currentText)
    }
    
    // MARK: - 메모 텍스트필드
    private func memoInfoTFDidChanged() {
        // MARK: - Fix
        guard let count = self.textField.text?.count else { return }
        if count > 12 {
            self.textField.deleteBackward()
            
        } else {
            // 글자 수 레이블 업데이트
            self.numOfCharLbl.text = self.viewModel?.updateMemoCount(
                count: count)
        }
    }
}










// MARK: - 텍스트필드 델리게이트

extension ReceiptWriteDataCell: UITextFieldDelegate {
    
    // MARK: - 수정 시작 시
    /// priceInfoTF의 수정을 시작할 때 ',' 및 '원'을 제거하는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 텍스트필드가 눌렸다고 delegate 전달
        self.delegate?.cellIsTapped(self, type: self.viewModel?.getReceiptEnum)
        
        
        // MARK: - Fix
        // 현재 enum이 '가격'일 때
        // textField가 빈칸이 아니라면,
        guard self.viewModel?.isTfBeginEditing ?? false,
              self.textField.text != "" else { return }

        // textField에 있는 '~원' 형식을 제거
        self.textField.text = self.viewModel?.removeWonFormat(
            priceText: self.textField.text)
    }
    
    // MARK: - 수정이 끝났을 때
    /// 텍스트 필드 수정이 끝났을 때
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드의 현재 텍스트를 변수에 저장
        let savedText = textField.text
        // 메모 텍스트필드일 때
        if self.viewModel?.isMemoType ?? false {

            self.finishMemoTF(text: savedText)
            
        // 가격 텍스트필드 일때
        } else {
            // 뷰모델에 price값 저장
            // 가격 레이블에 바뀐 가격을 ',' 및 '원'을 붙여 표시
            // 누적금액 레이블에 (지불금액 - 누적금액) 설정
            self.finishPriceTF(text: savedText)
        }
    }
    
    // MARK: - [저장] 메모 텍스트필드
    private func finishMemoTF(text: String?) {
        if let text = text, text != "" {
            self.delegate?.finishMemoTF(memo: text)
        }
    }
    
    
    // MARK: - [저장] 가격 텍스트필드
    /// 가격 텍스트필드의 수정이 끝났을 때 호출되는 메서드
    private func finishPriceTF(text: String?) {
        // Int값으로 바꾸기
        let priceInt = self.viewModel?.removeAllFormat(priceText: text) ?? 0
        // 뷰컨트롤러로 전달
        self.delegate?.finishPriceTF(price: priceInt)
        // 텍스트필드에 ',' 및 '원'형식 설정
        self.textField.text = self.viewModel?.priceInfoTFText(price: priceInt)
    }
}
