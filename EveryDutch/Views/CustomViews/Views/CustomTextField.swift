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
        let tf = InsetTextField()
        tf.delegate = self
        return tf
    }()
    /// 글자 수 레이블
    private lazy var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / \(self.TF_MAX_COUNT)",
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 최대 자리 수
    private var TF_MAX_COUNT: Int = 12
    /// 델리게이트
    weak var customTextFieldDelegate: CustomTextFieldDelegate?
    /// 현재 텍스트필드의 텍스트를 반환
    var currentText: String? {
        return self.textField.text
    }
    
    
    
    // MARK: - 라이프사이클
    init(insetX: CGFloat = 16,
         TF_MAX_COUNT: Int = 12,
         placeholder: String = "")
    {
        self.TF_MAX_COUNT = TF_MAX_COUNT
        super.init(frame: .zero)
        
        self.configureAutoLayout()
        self.configureTextFieldAction()
        
        self.textField.insetX = insetX
        self.textField.setPlaceholderText(text: placeholder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - 화면 설정
    private func configureAutoLayout() {
        self.addSubview(self.textField)
        self.addSubview(self.numOfCharLbl)
        // 텍스트필드
        self.textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 글자 수 세는 레이블
        self.numOfCharLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    /// 텍스트필드가 수정될 때마다 호출 되는 액션
    private func configureTextFieldAction() {
        self.textField.addTarget(
            self,
            action: #selector(self.textFieldIsChanged),
            for: .editingChanged)
    }
    /// 화면 추가 설정
    func setupUI(
        placeholerText: String = "",
        placeholerTextColor: UIColor = .placeholderText,
        keyboardType: UIKeyboardType = .default,
        numOfcharLblIsHidden: Bool = false
    ) { 
        // 플레이스홀더의 텍스트 설정
        self.textField.setPlaceholderText(
            text: placeholerText,
            color: placeholerTextColor)
        // 키보드 타입 설정
        self.textField.keyboardType = keyboardType
        // NumOfChar 레이블 숨기기
        self.numOfCharLbl.isHidden = numOfcharLblIsHidden
    }
    
    
    
    // MARK: - 액션
    /// 텍스트필드에 텍스트를 설정
    func setTFText(_ text: String?) {
        self.textField.text = text
    }
    
    /// NumOfChar 레이블에 텍스트를 설정
    func seteupNumOfCharLbl() {
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
