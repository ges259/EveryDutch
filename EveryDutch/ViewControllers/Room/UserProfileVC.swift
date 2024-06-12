//
//  UserProfileVC.swift
//  EveryDutch
//
//  Created by 계은성 on 6/10/24.
//

import UIKit
import SnapKit
import PanModal

final class UserProfileVC: UIViewController {
    // MARK: - 레이아웃
    /// 카드 이미지 뷰
    private lazy var cardImgView: CardImageView = {
        let view = CardImageView()
        let userDecoTuple = self.viewModel.getUserDecoTuple
            view.setupUserData(data: userDecoTuple.user)
            view.setupDecorationData(data: userDecoTuple.deco)
        return view
    }()
    /// 원형 버튼들
    private var searchBtn: UIButton = UIButton.btnWithImg(
        image: .Exit_Img,
        imageSize: 11,
        backgroundColor: UIColor.normal_white,
        title: "검색")
    private var reportBtn: UIButton = UIButton.btnWithImg(
        image: .Invite_Img,
        imageSize: 15,
        backgroundColor: UIColor.normal_white,
        title: "신고")
    private lazy var kickBtn: UIButton = UIButton.btnWithImg(
        image: .gear_Fill_Img,
        imageSize: 15,
        backgroundColor: UIColor.normal_white,
        title: "강퇴")
    
    /// 버튼으로 구성된 가로로 된 스택뷰
    private lazy var btnStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.searchBtn,
                           self.reportBtn],
        axis: .horizontal,
        spacing: 16,
        alignment: .fill,
        distribution: .equalSpacing)
    
    // MARK: - 프로퍼티
    
    
    let viewModel: UserProfileVMProtocol
    let coordinator: UserProfileCoordinator
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: UserProfileVMProtocol,
         coordinator: UserProfileCoordinator)
    {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dataChange(data: User) {
        self.cardImgView.setupUserData(data: data)
    }
}





// MARK: - 화면 설정
extension UserProfileVC {
    /// UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.deep_Blue
        [self.searchBtn,
         self.reportBtn,
         self.kickBtn].forEach { btn in
            btn.setRoundedCorners(.all, withCornerRadius: 50 / 2)
        }
        
        if self.viewModel.isRoomManager {
            self.btnStackView.addArrangedSubview(self.kickBtn)
        }
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.cardImgView)
        self.view.addSubview(self.btnStackView)
        
        
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(self.cardHeight())
        }
        self.btnStackView.snp.makeConstraints { make in
            make.top.equalTo(self.cardImgView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.cardImgView).inset(self.viewModel.btnStvInsets)
        }
        // 하단 버튼의 넓이 및 높이 설정
        self.searchBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
    }
    
    /// 액션 설정
    private func configureAction() {
        
    }
}





// MARK: - 팬모달 설정
extension UserProfileVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        return .contentHeight(self.cardHeight() + 50 + 17 + 10 + UIDevice.current.panModalSafeArea)
    }
    
    /// 화면 밖 - 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    /// 상단 인디케이터 없애기
    var showDragIndicator: Bool {
        return false
    }
    var cornerRadius: CGFloat {
        return 23
    }
}



// MARK: - 액션 설정
extension UserProfileVC {

}

