//
//  SettingVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import SnapKit

final class CardScreenVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    private var cardImgView: CardImageView = CardImageView()
    
    private lazy var roomInfoCardView: CardTextView = CardTextView(
        mode: self.viewModel.first_Mode)
    
    private lazy var userInfoCardView: CardTextView = {
        let view = CardTextView(
            mode: self.viewModel.second_Mode ?? .info_Btn)
        view.delegate = self
        return view
    }()
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.cardImgView,
                           self.roomInfoCardView],
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fillEqually)
    
    private lazy var clearView: UIView = UIView()
    
    
    private lazy var bottomBtn: BottomButton = BottomButton()
    
    
    // MARK: - 프로퍼티
    private var viewModel: CardScreenVMProtocol!
    private weak var coordinator: Coordinator!
    
    weak var delegate: MultiPurposeScreenDelegate?
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: CardScreenVM,
         coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CardScreenVC {
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        
        
        self.bottomBtn.isHidden = self.viewModel.bottomBtn_IsHidden
        
        if let btnTitle = self.viewModel.bottomBtn_Title  {
            self.bottomBtn.setTitle(btnTitle, for: .normal)
        }
        
        if self.viewModel.secondStv_IsHidden {
            self.stackView.addArrangedSubview(self.userInfoCardView)
        }
        
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.stackView)
        self.view.addSubview(self.bottomBtn)
        
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            
            if self.viewModel.bottomBtn_IsHidden {
                make.bottom.equalToSuperview().offset(-10)
            } else {
                make.bottom.equalToSuperview().offset(-UIDevice.current.bottomBtnHeight - 10)
            }
        }
        // 바텀뷰
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
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
        self.coordinator?.didFinish()
    }
}



extension CardScreenVC: CardTextDelegate {
    func firstStackViewTapped() {
        print(#function)
        self.delegate?.logout()
    }
    
    func secondStackViewTapped() {
        print(#function)
//        self.coordinator?.d
    }
    
    func editBtnTapped() {
        print(#function)
    }
}
