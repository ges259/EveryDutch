//
//  CardTextView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/29.
//

import UIKit
import SnapKit


final class CardEditView: UIView {
    
    // MARK: - 레이아웃
    // 타이틀 레이블
    private var titleLbl: CustomLabel = CustomLabel(
        font: UIFont.boldSystemFont(ofSize: 23))
    
    // 디테이르 레이블
    private lazy var firstDetailLbl: CustomLabel = CustomLabel(
        leftInset: 26)
    
    private lazy var secondDetailLbl: CustomLabel = CustomLabel(
        leftInset: 26)
    
    private lazy var thirdDetailLbl: CustomLabel = CustomLabel(
        leftInset: 26)
    
    
    // 정보 레이블
    private lazy var firstInfoLbl: CustomLabel = CustomLabel(
        textAlignment: .right,
        rightInset: 26)
    
    private lazy var secondInfoLbl: CustomLabel = CustomLabel(
        textAlignment: .right,
        rightInset: 26)
    
    private lazy var thirdInfoLbl: CustomLabel = CustomLabel(
        textAlignment: .right,
        rightInset: 26)
    
    
    // 텍스트 필드
    private lazy var firstTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholerColor: .lightGray)

    private lazy var secondTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholerColor: .lightGray)
    
    // 글자수 레이블
    
    
    private lazy var firstNumOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 10",
        font: UIFont.systemFont(ofSize: 13))
    
    private lazy var secondNumOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 10",
        font: UIFont.systemFont(ofSize: 13))
    
    
    // 버튼
    private lazy var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 13),
        backgroundColor: UIColor.deep_Blue)
    
    
    // 스택뷰
    private lazy var firstStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.firstDetailLbl],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var secondStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.secondDetailLbl],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var thirdStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.thirdDetailLbl,
                           self.thirdInfoLbl],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.firstStackView,
                           self.secondStackView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    private lazy var clearView: UIView = UIView()
    
    
    private lazy var editProfileBtn: UIButton = UIButton.btnWithImg(
        image: .note_Img,
        imageSize: 14)
    
    private lazy var copyBtn: UIButton = UIButton.btnWithImg(
        image: .copy_Img,
        imageSize: 10)
    
    
    
    
    // MARK: - 프로퍼티
    private var mode: CardMode?
    
    weak var delegate: CardTextDelegate?
    
    
    
    
    // MARK: - 라이프사이클
    init(mode: CardMode) {
        self.mode = mode
        super.init(frame: .zero)
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureMode()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension CardEditView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .medium_Blue
        self.addShadow(card: true)
        
        self.bottomBtn.clipsToBounds = true
        self.bottomBtn.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        self.bottomBtn.layer.cornerRadius = 10
        
        self.layer.cornerRadius = 10
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.titleLbl,
         self.totalStackView].forEach { view in
            self.addSubview(view)
        }
        self.titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(25)
            make.height.equalTo(30)
        }
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.firstDetailLbl.snp.makeConstraints { make in
            make.width.equalTo(125)
        }
        self.secondDetailLbl.snp.makeConstraints { make in
            make.width.equalTo(125)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}










// MARK: - 모드에 따른 설정

extension CardEditView {
    
    // MARK: - UI 설정
    private func configureMode() {
        guard let mode = self.mode else { return }
        self.configureText(mode: mode)
        
        switch mode {
        case .roomMake:
            self.configureStackView(
                first: self.firstTF,
                second: self.secondTF,
                third: self.bottomBtn)
            break
            
        case .roomFix:
            self.configureStackView(
                first: self.firstInfoLbl,
                second: self.secondTF,
                third: self.bottomBtn)
            break
            
        case .profile:
            self.configureStackView(
                first: self.firstInfoLbl,
                second: self.secondInfoLbl,
                third: self.clearView)
            break
            
        case .profile_Fix:
            self.configureStackView(
                first: self.firstInfoLbl,
                second: self.secondInfoLbl,
                third: self.bottomBtn)
            self.addEditBtnAction()
            break
            
        case .setting_Auth:
            self.configureStackView(
                first: self.firstInfoLbl,
                second: self.secondInfoLbl,
                third: self.clearView)
            self.addStackViewGesture()
            break
        }
    }
    
    // MARK: - 텍스트 설정
    private func configureText(mode: CardMode) {
        self.configureCommonSettings(mode)
        
        switch mode {
        case .roomMake:
            self.configureFirstTf()
            fallthrough
            
        case .roomFix:
            self.configureSecondTf(mode)
            fallthrough
    
        case .profile_Fix:
            self.configureBottomBtn(mode)
            break
            
        case .setting_Auth, .profile:  break
        }
    }
    
    // MARK: - 타이틀 및 디테일 설정
    private func configureCommonSettings(_ mode: CardMode) {
        self.titleLbl.text = mode.title
        let textArray: [String] = mode.description
        self.firstDetailLbl.text = textArray[0]
        self.secondDetailLbl.text = textArray[1]
    }
    
    // MARK: - 첫 번째 TF
    private func configureFirstTf() {
        self.firstTF.attributedPlaceholder = self.setAttributedText(
            placeholderText: CardMode.roomMake.firstTfPlaceholder)
    }
    
    // MARK: - 두 번째 TF
    private func configureSecondTf(_ mode: CardMode) {
        self.secondTF.attributedPlaceholder = self.setAttributedText(
            placeholderText: mode.secondTfPlaceholder)
    }
    
    // MARK: - 바텀 버튼
    private func configureBottomBtn(_ mode: CardMode) {
        self.bottomBtn.setTitle(mode.btnTitle, for: .normal)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 스택뷰에 추가
    private func configureStackView(first: UIView,
                                    second: UIView,
                                    third: UIView) {
        // 텍스트필드가 있다면 -> cornerRadius 설정
        self.tfCornerRadius([first, second])
        // 스택뷰에 뷰 추가
        self.firstStackView.addArrangedSubview(first)
        self.secondStackView.addArrangedSubview(second)
        self.totalStackView.addArrangedSubview(third)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 텍스트필드 코너레디어스
    private func tfCornerRadius(_ textFieldArray: [UIView]) {
        
        for view in textFieldArray {
            if let textField = view as? UITextField {
                
                textField.clipsToBounds = true
                textField.layer.maskedCorners = [.layerMinXMinYCorner]
                textField.layer.cornerRadius = 12
                
                // 첫 번째 텍스트 필드에 적용했다면 루프를 종료
                break
            }
        }
    }
    
    
    
    
    // MARK: - 프로필 수정 버튼 액션
    private func addEditBtnAction() {
        self.addSubview(self.editProfileBtn)
        self.editProfileBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-26)
            make.centerY.equalTo(self.titleLbl)
        }
        
        self.editProfileBtn.addTarget(
            self,
            action: #selector(self.editProfileBtnTapped),
            for: .touchUpInside)
//        self.thirdStackView.insertArrangedSubview(self.copyBtn, at: 1)
    }
    @objc private func editProfileBtnTapped() {
        print(#function)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - ect_Setting 제스쳐
    private func addStackViewGesture() {
        let firstStackViewGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.firstStackViewTapped))
        self.firstStackView.addGestureRecognizer(
            firstStackViewGesture)
        
        let secondStackViewGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.secondStackViewTapped))
        self.secondStackView.addGestureRecognizer(
            secondStackViewGesture)
    }
    @objc private func firstStackViewTapped() {
        print(#function)
        self.delegate?.firstStackViewTapped()
    }
    @objc private func secondStackViewTapped() {
        print(#function)
        self.delegate?.secondStackViewTapped()
    }
}
