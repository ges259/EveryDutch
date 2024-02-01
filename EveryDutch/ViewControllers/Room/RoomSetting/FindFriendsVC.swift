//
//  FindFriendsVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/30.
//

import UIKit
import SnapKit

// MARK: - FindFriendsVC
final class FindFriendsVC: UIViewController {
    
    // MARK: - 레이아웃
    private var textField: InsetTextField = InsetTextField(
        backgroundColor: UIColor.clear,
        placeholderText: "친구 개인 ID")
    
    private var numOfCharLbl: CustomLabel = CustomLabel(
        text: "0 / 8",
        font: UIFont.systemFont(ofSize: 13))
    
    private var searchBtn: UIButton = UIButton.btnWithTitle(
        title: "검색",
        font: UIFont.systemFont(ofSize: 15),
        backgroundColor: UIColor.deep_Blue)
    
    private var lineView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    private var cardImgView: CardImageView = CardImageView()
    
    private var inviteBtn: UIButton = UIButton.btnWithTitle(
        title: "초대하기",
        font: UIFont.boldSystemFont(ofSize: 16),
        backgroundColor: UIColor.deep_Blue)
    
    private lazy var topStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.textField,
                           self.numOfCharLbl,
                           self.searchBtn],
        axis: .horizontal,
        spacing: 20,
        alignment: .fill,
        distribution: .fill)
    
    private lazy var bottomStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.cardImgView,
                           self.inviteBtn],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    
    
    // MARK: - 프로퍼티
    var coordinator: Coordinator
    
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension FindFriendsVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = .base_Blue
        
        [self.searchBtn,
         self.inviteBtn].forEach { btn in
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 10
            btn.addShadow(shadowType: .card)
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.topStackView,
         self.lineView,
         self.bottomStackView].forEach { view in
            self.view.addSubview(view)
        }
        
        self.numOfCharLbl.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        self.searchBtn.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        self.topStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        self.lineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(self.topStackView.snp.bottom).offset(-2)
            make.leading.equalTo(self.topStackView).offset(10)
            make.trailing.equalTo(self.topStackView).offset(-20)
        }
        
        
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight)
        }
        self.inviteBtn.snp.makeConstraints { make in
            make.height.equalTo(53)
        }
        
        self.bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(self.topStackView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.topStackView)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
}
