////
////  ProfileVC.swift
////  EveryDutch
////
////  Created by 계은성 on 2023/12/30.
////
//
//import UIKit
//import SnapKit
//
//final class ProfileVC: UIViewController {
//    
//    // MARK: - 레이아웃
//    /// 스크롤뷰
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//            scrollView.bounces = false
//            scrollView.showsVerticalScrollIndicator = false
//            scrollView.alwaysBounceVertical = true
//        return scrollView
//    }()
//    /// 컨텐트뷰 ( - 스크롤뷰)
//    private lazy var contentView: UIView = UIView()
//    
//    private var cardImgView: CardImageView = CardImageView()
//    
//    private var roomInfoCardView: CardTextView = CardTextView(
//        mode: .nothingFix)
//    
//    private var userInfoCardView: CardTextView = CardTextView(
//        mode: .info_Setting)
//    
//    private lazy var stackView: UIStackView = UIStackView.configureStackView(
//        arrangedSubviews: [self.cardImgView,
//                           self.roomInfoCardView,
//                           self.userInfoCardView],
//        axis: .vertical,
//        spacing: 10,
//        alignment: .fill,
//        distribution: .fillEqually)
//    
//    
//    // MARK: - 프로퍼티
//    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
//    
//    
//    
//    // MARK: - 라이프사이클
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.configureUI()
//        self.configureAutoLayout()
//        self.configureAction()
//    }
//}
//
//// MARK: - 화면 설정
//
//extension ProfileVC {
//    
//    // MARK: - UI 설정
//    private func configureUI() {
//        
//    }
//    
//    // MARK: - 오토레이아웃 설정
//    private func configureAutoLayout() {
//        self.view.addSubview(self.scrollView)
//        self.scrollView.addSubview(self.contentView)
//        self.contentView.addSubview(self.stackView)
//        
//        // 스크롤뷰
//        self.scrollView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
//        }
//        // 카드 이미지 뷰
//        self.cardImgView.snp.makeConstraints { make in
//            make.height.equalTo(self.cardHeight)
//        }
//        // 컨텐트뷰
//        self.contentView.snp.makeConstraints { make in
//            make.edges.equalTo(self.scrollView.contentLayoutGuide)
//            make.width.equalTo(self.scrollView.frameLayoutGuide)
//        }
//        // 스택뷰
//        self.stackView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(2)
//            make.leading.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(-10)
////            make.bottom.equalToSuperview().offset(-10)
//        }
//    }
//    
//    // MARK: - 액션 설정
//    private func configureAction() {
//        
//    }
//}
