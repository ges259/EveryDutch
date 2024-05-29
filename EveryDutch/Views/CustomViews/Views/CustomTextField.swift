//
//  CustomTextField.swift
//  EveryDutch
//
//  Created by 계은성 on 5/29/24.
//

import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidBeginEditing(_ text: String?)
    func textFieldDidEndEditing(_ text: String?)
    func textFieldIsChanged(_ text: String?)
}
extension CustomTextFieldDelegate {
    /// 수정이 시작됐을 때
    func textFieldDidBeginEditing(_ text: String?) {
        print("Error 1")
    }
    /// 수정이 끝났을 때
    func textFieldDidEndEditing(_ text: String?) {
        print("Error 2")
    }
    /// 텍스트필드가 바뀌었을 때
    func textFieldIsChanged(_ text: String?) {
        print("Error 3")
    }
}


final class CustomTextField: UIView {
    // MARK: - 레이아웃
    /// 텍스트필드
    private lazy var textField: InsetTextField = {
        let tf = InsetTextField(
            backgroundColor: UIColor.normal_white,
            insetX: 25)
        tf.delegate = self
        tf.textColor = UIColor.black
        
        return tf
    }()
    /// 글자 수 레이블
    private lazy var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 12",
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    
    
    // MARK: - 프로퍼티
    private var TF_MAX_COUNT: Int = 12
    weak var customTextFieldDelegate: CustomTextFieldDelegate?
    
    private var currentText: String? {
        return self.textField.text
    }
    
    
    
    // MARK: - 라이프사이클
    init() {
        super.init(frame: .zero)
        self.configureAutoLayout()
        self.configureTextFieldAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - 화면 설정
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
    
    
    
    
    
    
    
    
    
    
    // MARK: - Fix
    private func setupUI(
        numOfChar: Int,
        placeholderText: String = "",
        textFieldText: String = ""
    ) {
        self.TF_MAX_COUNT = numOfChar
        self.seteupNumOfCharLbl()
    }
    private func setupUI(
        numOfChar: Int,
        
        placeholderText: String = "",
        placeholderColor: UIColor = UIColor.placeholder_gray,
        
        backgroundColor: UIColor = UIColor.normal_white,
        
        keyboardType: UIKeyboardType = .default,
        keyboardReturnType: UIReturnKeyType = .done
    ) {
        self.textField.setPlaceholderText(
            text: placeholderText,
            color: placeholderColor)
        self.textField.backgroundColor = backgroundColor
        
        self.textField.keyboardType = keyboardType
        self.textField.returnKeyType = keyboardReturnType
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func setPlaceholderText(_ text: String) {
        self.textField.setPlaceholderText(text: text)
    }
    func setKeyboardType(_ type: UIKeyboardType) {
        self.textField.keyboardType = type
    }
    func setTFText(_ text: String?) {
        self.textField.text = text
    }
    private func seteupNumOfCharLbl() {
        let numOfChar = self.currentText?.count ?? 0
        
        self.numOfCharLbl.text = "\(numOfChar) / \(self.TF_MAX_COUNT)"
    }
}










// MARK: - 텍스트필드 델리게이트
extension CustomTextField: UITextFieldDelegate {
    
    @objc private func textFieldIsChanged() {
        guard let count = self.currentText?.count else { return }
        
        if count > self.TF_MAX_COUNT {
            self.textField.deleteBackward()
            
        } else {
            // 글자 수 레이블 업데이트
            self.seteupNumOfCharLbl()
            // 델리게이트 전달
            self.customTextFieldDelegate?.textFieldIsChanged(self.currentText)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.customTextFieldDelegate?.textFieldDidBeginEditing(self.currentText)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.customTextFieldDelegate?.textFieldDidEndEditing(self.currentText)
    }
}
