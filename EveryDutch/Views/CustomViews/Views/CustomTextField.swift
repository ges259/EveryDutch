//
//  CustomTextField.swift
//  EveryDutch
//
//  Created by 계은성 on 5/29/24.
//

import UIKit

protocol CustomTextFieldDelegate: AnyObject {}
extension CustomTextFieldDelegate {
    /// 수정이 시작됐을 때
    func textFieldDidBeginEditing() {}
    /// 수정이 끝났을 때
    func textFieldDidEndEditing() {}
    /// 텍스트필드가 바뀌었을 때
    func textFieldIsChanged() {}
    
}


final class CustomTextField: UIView {
    // MARK: - 레이아웃
    /// 텍스트필드
    private lazy var textField: InsetTextField = {
        let tf = InsetTextField(
            backgroundColor: UIColor.normal_white,
            insetX: 25)
        tf.delegate = self
        return tf
    }()
    /// 글자 수 레이블
    private lazy var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 12",
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    
    
    // MARK: - 프로퍼티
//    private let numOfChar: Int
    weak var customTextFieldDelegate: CustomTextFieldDelegate?
    
    
    
    
    
    // MARK: - 라이프사이클
    init() {
        super.init(frame: .zero)
        self.configureTextFieldAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - 화면 설정
    private func setupUI(
        numOfChar: Int,
        placeholderText: String,
        keyboardType: UIKeyboardType = .default
    ) {
        
        self.numOfCharLbl.text = "0 / \(numOfChar)"
        self.textField.setPlaceholderText(
            text: placeholderText)
        self.textField.keyboardType = keyboardType
    }
    private func configureAutoLayout() {
        self.addSubview(self.textField)
        self.addSubview(self.numOfCharLbl)
        
        self.textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 글자 수 세는 레이블
        self.numOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    private func configureTextFieldAction() {
        self.textField.addTarget(
            self,
            action: #selector(self.textFieldIsChanged),
            for: .editingChanged)
    }
}
extension CustomTextField: UITextFieldDelegate {
    
    @objc private func textFieldIsChanged() {
        self.customTextFieldDelegate?.textFieldIsChanged()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.customTextFieldDelegate?.textFieldDidBeginEditing()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.customTextFieldDelegate?.textFieldDidEndEditing()
    }
}

