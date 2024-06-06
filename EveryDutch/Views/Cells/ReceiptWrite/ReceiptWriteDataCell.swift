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
    /// 좌측 [이미지 + 레이블] 스택뷰
    private lazy var cellStv: ReceiptLblStackView = ReceiptLblStackView(
        receiptEnum: self.viewModel?.getReceiptEnum ?? .time)
    
    /// 텍스트필드
    private lazy var textField: CustomTextField = {
        let maxCount = self.viewModel?.returnTextFieldMaxCount
        let tf = CustomTextField(insetX: 25,
                                 TF_MAX_COUNT: maxCount)
        tf.customTextFieldDelegate = self
        return tf
    }()
    
    /// 우측 레이블
    private lazy var label: CustomLabel = CustomLabel(
        textColor: UIColor.black,
        font: UIFont.systemFont(ofSize: 12.5),
        backgroundColor: UIColor.normal_white,
        leftInset: 25)
    
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: ReceiptWriteDataCellDelegate?
    private var viewModel: ReceiptWriteDataCellVMProtocol?
    
    
    
    
    
    // MARK: - 라이프사이클
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellStv.layer.cornerRadius = 0
        self.layer.cornerRadius = 0
    }
    func configureCell(viewModel: ReceiptWriteDataCellVMProtocol?) {
        self.viewModel = viewModel
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureViewWithEnum()
    }
    /// 첫 번째 셀
    func configureFirstCell() {
        // 스택뷰의 모서리 설정
        self.cellStv.setRoundedCorners(.rightTop, withCornerRadius: 10)
    }
    /// 마지막 셀
    func configureLastCell() {
        // 스택뷰의 모서리 설정
        self.cellStv.setRoundedCorners(.rightBottom, withCornerRadius: 10)
        // 셀의 모서리 설정
        self.setRoundedCorners(.bottom, withCornerRadius: 10)
    }
}










// MARK: - 화면 설정
extension ReceiptWriteDataCell {
    /// UI 설정
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .normal_white
        
        self.cellStv.backgroundColor = .medium_Blue
    }
    
    /// [공통] 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.cellStv)
        self.cellStv.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    /// 텍스트필드 오토레이아웃 설정
    private func configureTextFieldAutoLayout() {
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    /// 레이블 오토레이아웃 설정
    private func configureLabelAutoLayout() {
        self.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.leading.equalTo(self.cellStv.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
        // 레이블 액션 설정
        self.configureLabelAction()
    }
    
    /// 레이블 액션 설정
    private func configureLabelAction() {
        // '계산한 사람' 레이블 제스처 생성
        let dateGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.labelTapped))
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(dateGesture)
    }
}




    





// MARK: - Enum에 따른 화면 설정
extension ReceiptWriteDataCell {
    private func configureViewWithEnum() {
        // 현재 type가져오기
        guard let receiptEnum = self.viewModel?.getReceiptEnum else { return }
        // type 분기처리
        switch receiptEnum {
        case .date:     self.configureDateUI()
        case .time:     self.configureTimeUI()
        case .memo:     self.configureMemoUI()
        case .price:    self.configurePriceUI()
        case .payer:    self.configurePayerUI()
        case .payment_Method: break
        }
    }
    
    /// 날짜
    private func configureDateUI() {
        self.configureLabelAutoLayout()
        self.setDateString()
    }
    
    /// 시간
    private func configureTimeUI() {
        self.configureLabelAutoLayout()
        // 레이블 텍스트 설정
        self.label.text = self.viewModel?.getCurrentTime()
    }
    
    /// 메모
    private func configureMemoUI() {
        self.configureTextFieldAutoLayout()
        self.textField.setupUI(
            placeholerText: "메모을 입력해 주세요.")
    }
    
    /// 가격
    private func configurePriceUI() {
        self.configureTextFieldAutoLayout()
        
        self.textField.setupUI(
            placeholerText: "가격을 입력해 주세요.",
            keyboardType: .numberPad,
            numOfcharLblIsHidden: true)
    }
    
    /// 계산
    private func configurePayerUI() {
        self.configureLabelAutoLayout()
        
        self.label.attributedText = NSAttributedString.configure(
            text: "계산한 사람을 설정해 주세요.",
            color: UIColor.placeholder_gray,
            font: UIFont.systemFont(ofSize: 13))
    }
}










// MARK: - 셀 업데이트
// 뷰컨트롤러에서 셀을 업에이트하는 함수들
extension ReceiptWriteDataCell {
    /// 레이블 텍스트 설정
    func setLabelText(text: String?) {
        self.label.text = text
    }
    
    /// 날짜 텍스트 설정
    func setDateString(date: Date = Date()) {
        let dateText = Date.returnYearString(date: date)
        self.label.text = dateText
    }
}
    
    
    
    
    


    
    
    
// MARK: - 액션
extension ReceiptWriteDataCell {
    @objc private func labelTapped() {
        self.delegate?.cellIsTapped(self, type: self.viewModel?.getReceiptEnum)
    }
}










// MARK: - 텍스트필드 델리게이트
extension ReceiptWriteDataCell: CustomTextFieldDelegate {
    /// 수정이 시작됐을 때
    func textFieldDidBeginEditing(_ text: String?) {
        // 텍스트필드가 눌렸다고 delegate 전달
        self.delegate?.cellIsTapped(self, type: self.viewModel?.getReceiptEnum)
        
        // 현재 enum이 '가격(price)'일 때
        // textField가 빈칸이 아니라면,
        guard self.viewModel?.isPriceType ?? false,
              text != "" else { return }

        let formattingText = self.viewModel?.removeWonFormat(
            priceText: text)
        // textField에 있는 '~원' 형식을 제거
        self.textField.setTFText(formattingText)
    }
    
    
    
    
    
    /// 수정이 끝났을 때
    func textFieldDidEndEditing(_ text: String?) {
        // 텍스트 필드의 현재 텍스트를 변수에 저장
        let savedText = text
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
    /// [저장] 메모 텍스트필드
    private func finishMemoTF(text: String?) {
        if let text = text, text != "" {
            self.delegate?.finishMemoTF(memo: text)
        }
    }
    /// 가격 텍스트필드의 수정이 끝났을 때 호출되는 메서드
    private func finishPriceTF(text: String?) {
        // Int값으로 바꾸기
        let priceInt = self.viewModel?.removeAllFormat(priceText: text) ?? 0
        // 뷰컨트롤러로 전달
        self.delegate?.finishPriceTF(price: priceInt)
        // 텍스트필드에 ',' 및 '원'형식 설정
        let formattingText = self.viewModel?.priceInfoTFText(price: priceInt)
        self.textField.setTFText(formattingText)
    }
    
    
    
    
    
    /// 텍스트필드가 바뀌었을 때
    func textFieldIsChanged(_ text: String?) {
        guard self.viewModel?.isPriceType ?? false else { return }
        self.priceInfoTFDidChanged(text)
    }
    /// 가격 텍스트필드
    private func priceInfoTFDidChanged(_ text: String?) {
        guard let currentText = text else { return }
        // 포매팅된 문자열로 텍스트 필드 업데이트
        let formattingText = self.viewModel?.formatPriceForEditing(currentText)
        self.textField.setTFText(formattingText)
    }
}
