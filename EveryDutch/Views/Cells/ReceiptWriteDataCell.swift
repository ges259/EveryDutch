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
        receiptEnum: self.viewModel?.getReceiptEnum ?? .time)
    
    
    
    private lazy var textField: InsetTextField = {
        let tf = InsetTextField(
            backgroundColor: UIColor.normal_white,
            placeholderText: "메모를 입력해 주세요.",
            insetX: 25)
        tf.delegate = self
        return tf
    }()
    
    private lazy var label: CustomLabel = CustomLabel(
        backgroundColor: UIColor.normal_white,
        leftInset: 25)
    
    
    private lazy var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / \(self.viewModel?.TF_MAX_COUNT ?? 12)",
        font: UIFont.systemFont(ofSize: 13))
    
    // MARK: - 프로퍼티
    weak var delegate: ReceiptWriteDataCellDelegate?
    
    private var viewModel: ReceiptWriteDataCellVMProtocol?
    
    
    
    
    
    // MARK: - 라이프사이클
    func configureCell(viewModel: ReceiptWriteDataCellVMProtocol) {
        self.viewModel = viewModel
        
        self.configureUI()
        self.configureAutoLayout()
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
    

        

    
    // MARK: - Enum에 따른 설정
    private func configureViewWithEnum() {
        guard let receiptEnum = self.viewModel?.getReceiptEnum else { return }
        
        switch receiptEnum {
        case .time:
            self.configureLabel()
            self.configureTimeLblAction()
        case .payer:
            self.configureLabel()
            self.configurePayerLblAction()
            break
        case .price:
            self.configureTextField()
            self.configurePriceTfAction()
            break
            
        case .memo:
            self.configureTextField()
            self.configureNumOfCharLbl()
            self.configureMemoTfAction()
            break
        case .payment_Method, .date:
            break
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 텍스트필드 오토레이아웃
    private func configureTextField() {
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 글자 수 오토레이아웃
    private func configureNumOfCharLbl() {
        self.addSubview(self.numOfCharLbl)
        // 글자 수 세는 레이블
        self.numOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configurePriceTfAction() {
        self.textField.addTarget(
            self,
            action: #selector(self.priceInfoTFDidChanged),
            for: .editingChanged)
    }
    private func configureMemoTfAction() {
        self.textField.addTarget(
            self,
            action: #selector(self.memoInfoTFDidChanged),
            for: .editingChanged)
    }
    
    
    
    
    
    
    // MARK: - 레이블 오토레이아웃
    private func configureLabel() {
        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configurePayerLblAction() {
        // '계산한 사람' 레이블 제스처 생성
        let payerGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.payerInfoLblTapped))
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(payerGesture)
    }
    private func configureTimeLblAction() {
        // '시간' 레이블 제스처 설정
        let timeGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.timeInfoLblTapped))
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(timeGesture)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc private func timeInfoLblTapped() {
        self.delegate?.timeLblTapped()
    }
    @objc private func payerInfoLblTapped() {
        self.delegate?.payerLblTapped()
    }
    
    // MARK: - [액션] 가격 텍스트필드
    @objc private func priceInfoTFDidChanged() {
        // MARK: - Fix
        guard let currentText = self.textField.text else { return }

        // 포매팅된 문자열로 텍스트 필드 업데이트
        self.textField.text = self.viewModel?.formatPriceForEditing(currentText)
    }
    
    // MARK: - [액션] 메모 텍스트필드
    @objc private func memoInfoTFDidChanged() {
        // MARK: - Fix
        guard let count = self.textField.text?.count else { return }
        
        if count > 12 {
            self.textField.deleteBackward()

        } else {
            // 레이블 업데이트
            self.label.text = self.viewModel?.updateMemoCount(
                count: count)
        }
    }
}










// MARK: - 텍스트필드 델리게이트

extension ReceiptWriteDataCell: UITextFieldDelegate {
    
    // MARK: - 텍스트필드 수정 시작 시
    /// priceInfoTF의 수정을 시작할 때 ',' 및 '원'을 제거하는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        let savedText = textField.text ?? ""
        // MARK: - Fix
        // 메모 텍스트필드일 때
        if self.viewModel?.isMemoType ?? false {
            // MARK: - memo
            self.delegate?.finishMemoTF(memo: savedText)
            
        // 가격 텍스트필드 일때
        } else {
            // 뷰모델에 price값 저장
            // 가격 레이블에 바뀐 가격을 ',' 및 '원'을 붙여 표시
            // 누적금액 레이블에 (지불금액 - 누적금액) 설정
            self.finishPriceTF(text: savedText)
        }
    }
    
    // MARK: - [저장] 가격 텍스트필드
    /// 가격 텍스트필드의 수정이 끝났을 때 호출되는 메서드
    private func finishPriceTF(text: String?) {
        
        let priceInt = self.viewModel?.removeAllFormat(
            priceText: text) ?? 0
        
        // MARK: - 뷰컨트롤러로 전달
        self.delegate?.finishPriceTF(
            price: priceInt)
        
        // 텍스트필드에 ',' 및 '원'형식 설정
        self.textField.text = self.viewModel?.priceInfoTFText(price: priceInt)
    }
}
