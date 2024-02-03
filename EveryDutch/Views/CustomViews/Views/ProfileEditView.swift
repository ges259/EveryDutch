//
//  CardProfileView.swift
//  EveryDutch
//
//  Created by 계은성 on 1/30/24.
//

import UIKit
import SnapKit

//final class ProfileEditView: UIView {
//    // MARK: - 레이아웃
//    // 타이틀 레이블
//    private var titleLbl: CustomLabel = CustomLabel(
//        font: UIFont.boldSystemFont(ofSize: 23))
//    
//    
//    
//    // 디테이르 레이블
//    private lazy var firstDetailLbl: CustomLabel = CustomLabel(
//        leftInset: 26)
//    
//    private lazy var secondDetailLbl: CustomLabel = CustomLabel(
//        leftInset: 26)
//    
//    
//    
//    // 정보 레이블
//    private lazy var firstInfoLbl: CustomLabel = CustomLabel(
//        textAlignment: .right,
//        rightInset: 26)
//    
//    private lazy var secondInfoLbl: CustomLabel = CustomLabel(
//        textAlignment: .right,
//        rightInset: 26)
//    
//    // 스택뷰
//    private lazy var firstStackView: UIStackView = UIStackView.configureStv(
//        arrangedSubviews: [self.firstDetailLbl],
//        axis: .horizontal,
//        spacing: 10,
//        alignment: .fill,
//        distribution: .fill)
//    
//    private lazy var clearView: UIView = UIView()
//    
//    private lazy var editProfileBtn: UIButton = UIButton.btnWithImg(
//        image: .note_Img,
//        imageSize: 14)
//    private lazy var copyBtn: UIButton = UIButton.btnWithImg(
//        image: .copy_Img,
//        imageSize: 10)
//    
//    
//    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
//        arrangedSubviews: [self.firstStackView,
//                           self.secondStackView],
//        axis: .vertical,
//        spacing: 0,
//        alignment: .fill,
//        distribution: .fillEqually)
//    
//    
//    
//    
//    
//    
//    private lazy var secondStackView: UIStackView = UIStackView.configureStv(
//        arrangedSubviews: [self.secondDetailLbl],
//        axis: .horizontal,
//        spacing: 10,
//        alignment: .fill,
//        distribution: .fill)
//    
//    
//    // MARK: - 프로퍼티
//    private var mode: CardMode?
//    
//    
//    // MARK: - 라이프사이클
//    init(mode: CardMode) {
//        self.mode = mode
//        super.init(frame: .zero)
//        self.configureUI()
//        self.configureAutoLayout()
//        self.configureAction()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - 화면 설정
//
//extension ProfileEditView {
//    
//    // MARK: - UI 설정
//    private func configureUI() {
//        self.backgroundColor = .medium_Blue
//        
//        
//        
//        self.layer.cornerRadius = 10
//    }
//    
//    // MARK: - 오토레이아웃 설정
//    private func configureAutoLayout() {
//        [self.titleLbl,
//         self.totalStackView].forEach { view in
//            self.addSubview(view)
//        }
//        self.titleLbl.snp.makeConstraints { make in
//            make.top.leading.equalToSuperview().offset(25)
//            make.height.equalTo(30)
//        }
//        self.totalStackView.snp.makeConstraints { make in
//            make.top.equalTo(self.titleLbl.snp.bottom).offset(15)
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//        self.firstDetailLbl.snp.makeConstraints { make in
//            make.width.equalTo(125)
//        }
//        self.secondDetailLbl.snp.makeConstraints { make in
//            make.width.equalTo(125)
//        }
//    }
//    
//    // MARK: - 액션 설정
//    private func configureAction() {
//        
//    }
//}
