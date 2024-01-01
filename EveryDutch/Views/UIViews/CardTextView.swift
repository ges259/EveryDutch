//
//  CardTextView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/29.
//

import UIKit
import SnapKit

final class CardTextView: UIView {
    
    // MARK: - 레이아웃
    // 타이틀 레이블
    private var titleLbl: UILabel = UILabel.configureLbl(
        font: UIFont.boldSystemFont(ofSize: 23))
    
    // 디테이르 레이블
    private var firstDetailLbl: PaddingLabel = PaddingLabel(leftInset: 26)
    
    private var secondDetailLbl: PaddingLabel = PaddingLabel(leftInset: 26)
    
    private lazy var thirdDetailLbl: PaddingLabel = PaddingLabel(leftInset: 26)
    
    
    // 정보 레이블
    private var firstInfoLbl: PaddingLabel = PaddingLabel(
        alignment: .right)
    
    private var secondInfoLbl: PaddingLabel = PaddingLabel(
        alignment: .right)
    
    private lazy var thirdInfoLbl: PaddingLabel = PaddingLabel(
        alignment: .right)
    
    
    // 텍스트 필드
    private lazy var firstTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholerColor: .lightGray,
        placeholderText: "안녕하세요.")

    private lazy var secondTF: InsetTextField = InsetTextField(
        backgroundColor: .normal_white,
        placeholerColor: .lightGray,
        placeholderText: "안녕하세요.")
    
    // 글자수 레이블
    
    
    private lazy var firstNumOfCharLbl: UILabel = UILabel.configureLbl(
        text: "0 / 10",
        font: UIFont.systemFont(ofSize: 13))
    
    private lazy var secondNumOfCharLbl: UILabel = UILabel.configureLbl(
        text: "0 / 10",
        font: UIFont.systemFont(ofSize: 13))
    
    
    // 버튼
    private lazy var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 13),
        backgroundColor: UIColor.deep_Blue)
    
    
    // 스택뷰
    private lazy var firstStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.firstDetailLbl],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var secondStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.secondDetailLbl],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var thirdStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.thirdDetailLbl,
                           self.thirdInfoLbl],
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.firstStackView,
                           self.secondStackView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    private lazy var clearView: UIView = UIView()
    
    
    private lazy var editProfileBtn: UIButton = UIButton.btnWithImg(
        imageEnum: .note,
        imageSize: 14)
    
    
    
    
    // MARK: - 프로퍼티
    private var mode: CardTextMode?
    
    
    
    
    
    // MARK: - 라이프사이클
    init(mode: CardTextMode) {
        
        super.init(frame: .zero)
        self.mode = mode
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

extension CardTextView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .medium_Blue
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
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
            make.width.equalTo(110)
        }
        self.secondDetailLbl.snp.makeConstraints { make in
            make.width.equalTo(110)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}

extension CardTextView {
    private func configureMode() {
        
        self.titleLbl.text = "정산방 정보"
        self.firstDetailLbl.text = "정산방 이름"
        self.secondDetailLbl.text = "모임 이름"
        
        guard let mode = mode else { return }
        switch mode {
        case .roomFix:
            
            self.configureStackView(first: self.firstTF,
                                    second: self.secondTF,
                                    third: bottomBtn)
            
            // MARK: - Fix
            self.firstTF.text = "대학 동기 방"
            self.secondTF.text = "점메추좀"
            self.bottomBtn.setTitle("배경 이미지 설정", for: .normal)
            break
             
        case .userInfoFix:
            self.configureStackView(first: self.firstInfoLbl,
                                    second: self.secondTF,
                                    third: self.bottomBtn)
            
            // MARK: - Fix
            self.firstInfoLbl.text = "첫번째"
            self.secondTF.text = "첫dfsa번째"
            self.bottomBtn.setTitle("배경 이미지 설정", for: .normal)
            break
            
        case .nothingFix:
            self.configureStackView(first: self.firstInfoLbl,
                                    second: self.secondInfoLbl,
                                    third: self.thirdStackView)
            
            // MARK: - Fix
            self.firstDetailLbl.text = "11"
            self.secondDetailLbl.text = "22"
            self.thirdDetailLbl.text = "세dfsa번째"
            
            self.firstInfoLbl.text = "첫번째"
            self.secondInfoLbl.text = "첫dfsa번째"
            self.thirdInfoLbl.text = "세dfsa번째"
            break
        case .info_Setting:
            self.configureStackView(first: self.firstInfoLbl,
                                    second: self.secondInfoLbl,
                                    third: self.thirdStackView)
            self.addEditBtnAction()
            
            
            self.firstInfoLbl.text = "첫번째"
            self.secondInfoLbl.text = "첫dfsa번째"
            self.thirdInfoLbl.text = "세dfsa번째"
            
            self.thirdDetailLbl.text = "324fds"
            break
            
        case .ect_Setting:
            self.configureStackView(first: self.firstInfoLbl,
                                    second: self.secondInfoLbl,
                                    third: self.clearView)
            self.firstInfoLbl.alpha = 0
            self.secondInfoLbl.alpha = 0
//            self.totalStackView.addArrangedSubview(self.clearView)
            self.addStackViewGesture()
            break
        }
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
                textField.clipsToBounds = true
                textField.layer.cornerRadius = 12
                
                // 첫 번째 텍스트 필드에 적용했다면 루프를 종료
                break
            }
        }
    }
    
    
    
    
    // MARK: - info_Setting 버튼 액션
    private func addEditBtnAction() {
        self.addSubview(self.editProfileBtn)
        self.editProfileBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-26)
            make.centerY.equalTo(self.titleLbl)
        }
        self.editProfileBtn.addTarget(self, action: #selector(self.editProfileBtnTapped), for: .touchUpInside)
    }
    @objc private func editProfileBtnTapped() {
        print(#function)
    }
    
    
    
    
    // MARK: - ect_Setting 제스쳐
    private func addStackViewGesture() {
        let firstStackViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.firstStackViewTapped))
        self.firstStackView.addGestureRecognizer(firstStackViewGesture)
        
        let secondStackViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.secondStackViewTapped))
        self.secondStackView.addGestureRecognizer(secondStackViewGesture)
    }
    @objc private func firstStackViewTapped() {
        print(#function)
    }
    @objc private func secondStackViewTapped() {
        print(#function)
    }
    
    
    

    
}
