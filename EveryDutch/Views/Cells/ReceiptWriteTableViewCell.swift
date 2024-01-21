//
//  ReceiptWriteTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

final class ReceiptWriteTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var tableCellStackView: TableCellStackView = TableCellStackView(
        rightImgInStackView: false)
    
    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        image: .x_Mark_Img,
        imageSize: 13)
    
    lazy var priceTf: InsetTextField = {
        let tf = InsetTextField(
            placeholderText: "가격을 입력해 주세요.",
            keyboardType: .numberPad,
            keyboardReturnType: .done,
            insertX: 25)
        tf.backgroundColor = UIColor.medium_Blue
        tf.isHidden = true
        tf.delegate = self
        return tf
    }()
    

    // MARK: - 프로퍼티
    var viewModel: ReceiptWriteCellVM?
    weak var delegate: ReceiptWriteTableDelegate?
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, 
                   reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool,
                              animated: Bool) {
        super.setSelected(selected, animated: animated)
        // priceTf가 selected(보여진 상태)라면
            // -> priceTf숨기기
        
            // 선택된 셀의 priceTF만 보이게 하고, 나머지 셀은 숨기기
        if selected {
            self.priceTf.isHidden = false
            self.priceTf.becomeFirstResponder()
            
        } else {
            self.priceTf.isHidden = true
        }
    }
}

// MARK: - 화면 설정

extension ReceiptWriteTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
        
        self.priceTf.layer.maskedCorners = [
            .layerMinXMinYCorner, // 좌상단
            .layerMinXMaxYCorner] // 좌하단
        
        self.priceTf.clipsToBounds = true
        self.priceTf.layer.cornerRadius = 10
    }
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.tableCellStackView)
        self.contentView.addSubview(self.rightBtn)
        self.contentView.addSubview(self.priceTf)
        
        self.rightBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(21)
        }
        self.tableCellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.rightBtn.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        self.priceTf.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(self.frame.width / 2)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.rightBtn.addTarget(
            self,
            action: #selector(self.rightBtnTapped),
            for: .touchUpInside)
        
        self.priceTf.addTarget(
            self, 
            action: #selector(self.priceTfDidChanged),
            for: .editingChanged)
    }
    

    
    
    
    
    
    
    
    
    // MARK: - 셀 설정
    func configureCell(with viewModel: ReceiptWriteCellVM) {
        self.viewModel = viewModel
        
        self.tableCellStackView.userNameLbl.text = viewModel.userName
        self.tableCellStackView.profileImg.image = viewModel.profileImg
        self.tableCellStackView.priceLbl.text = "0원"
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 오른쪽 버튼 액션
    @objc private func rightBtnTapped() {
        self.delegate?.rightBtnTapped(
            self,
            userID: self.viewModel?.userID)
    }
}










// MARK: - 텍스트필드 델리게이트

extension ReceiptWriteTableViewCell: UITextFieldDelegate {
    
    @objc private func priceTfDidChanged() {
        // 현재 텍스트 가져오기
        let currentText = self.priceTf.text
        
        // 포매팅된 문자열로 텍스트 필드 업데이트
        self.priceTf.text = self.viewModel?.configureTfFormat(
            text: currentText)
    }
    
    // MARK: - 텍스트필드 수정 시작 시
    /// priceInfoTF의 수정을 시작할 때 '0'이면, '0'을 제거하는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 현재 텍스트 가져오기
        let currentText = self.priceTf.text
        // 텍스트가 "0"인지 검사 -> "0"이라면 ""로 바꿈
        self.priceTf.text = self.viewModel?.textIsZero(
            text: currentText)
    }
    
    // MARK: - 수정이 끝났을 때
    /// 텍스트 필드 수정이 끝났을 때
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 뷰모델 옵셔널 바인딩
        guard let viewModel = self.viewModel else { return }
        
        // 텍스트필드 숨기기
        self.priceTf.isHidden = true
        
        // 최종 텍스트 가져오기
        let savedText = textField.text
        
        // 형식 제거
        let priceInt = viewModel.removeFormat(text: savedText)
        
        // ',' 및 '~원' 형식 추가
        self.tableCellStackView.priceLbl.text = viewModel.configureLblFormat(price: priceInt)
        
        // 델리게이트 - 가격 계산
        self.delegate?.setprice(userID: viewModel.userID,
                                price: Int(priceInt))
    }
}
