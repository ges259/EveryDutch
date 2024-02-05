//
//  ReceiptWriteTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

final class ReceiptWriteUsersCell: UITableViewCell {
    
    // MARK: - 레이아웃
    // 스택뷰(이미지, 이름, 가격레이블)
    private var tableCellStackView: TableCellStackView = TableCellStackView(
        rightImgInStackView: false)
    /// 오른쪽 버튼
    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        image: .x_Mark_Img,
        imageSize: 13)
    
    /// 가격 텍스트필드
    lazy var priceTf: InsetTextField = {
        let tf = InsetTextField(
            placeholderText: "가격을 입력해 주세요.",
            keyboardType: .numberPad,
            keyboardReturnType: .done,
            insertX: 25)
        tf.backgroundColor = UIColor.medium_Blue
        tf.isHidden = true
        tf.alpha = 0
        tf.delegate = self
        return tf
    }()
    

    // MARK: - 프로퍼티
    var viewModel: ReceiptWriteCellVMProtocol?
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
        self.configurePriceTF(selected)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.tableCellStackView.userNameLbl.text = ""
        self.tableCellStackView.profileImg.image = nil
        self.tableCellStackView.priceLbl.text = "0원"
        self.priceTf.text = ""
    }
}

// MARK: - 화면 설정

extension ReceiptWriteUsersCell {
    
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
        
        // 오른쪽 버튼
        self.rightBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(21)
        }
        // 스택뷰(이미지, 이름, 가격레이블)
        self.tableCellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.rightBtn.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        // 가격 텍스트필드
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
    func configureCell(with viewModel: ReceiptWriteCellVMProtocol) {
        self.viewModel = viewModel
        
        self.tableCellStackView.userNameLbl.text = viewModel.userName
        self.tableCellStackView.profileImg.image = viewModel.profileImg
    }
    
    
    // MARK: - 더치 버튼 셀 설정
    func configureDutchBtn(price: Int) {
        guard let viewModel = self.viewModel else { return }
        
        self.tableCellStackView.priceLbl.text = viewModel.configureLblFormat(
            price: "\(price)")
        
        self.priceTf.text = viewModel.configureTfFormat(
            text: "\(price)")
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 오른쪽 버튼 액션
    @objc private func rightBtnTapped() {
        self.delegate?.rightBtnTapped(
            user: self.viewModel?.roomUserDataDictionary)
    }
    
    // MARK: - 셀 선택 시 가격 텍스트필드 설정
    private func configurePriceTF(_ selected: Bool) {
        
        // priceTf가 selected(보여진 상태)에 따라 isHidden 설정
        self.priceTf.isHidden = !selected
        
        // 뷰모델 옵셔널 바인딩
        guard let viewModel = self.viewModel else { return }
        
        // 숨기거나 보이게 할 때 애니메이션 효과 넣기
        UIView.animate(withDuration: 0.3) {
            // 선택된 셀의 priceTF만 보이게 하고, 나머지 셀은 숨기기
            self.priceTf.alpha = viewModel.priceTFAlpha(isSelected: selected)
        }
        
        // 셀이 선택되었다면 -> 키보드 보이게 하기
        if selected { self.priceTf.becomeFirstResponder() }
    }
}










// MARK: - 텍스트필드 델리게이트

extension ReceiptWriteUsersCell: UITextFieldDelegate {
    
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
        self.tableCellStackView.priceLbl.text = viewModel.configureLblFormat(
            price: priceInt)
        
        // 델리게이트 - 가격 계산
        self.delegate?.setprice(userID: viewModel.userID,
                                price: Int(priceInt))
    }
}
