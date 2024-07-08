//
//  FloatingButtonView.swift
//  EveryDutch
//
//  Created by 계은성 on 7/2/24.
//

import UIKit
import SnapKit

protocol FloatingButtonViewDelegate: AnyObject {
    /// 방 생성 액션 (플러스 버튼)
    func goToRoomEditScreen()
    /// 프로필 액션 (사람 이미지 버튼)
    func goToProfileScreen()
    
    func floatingViewIsHidden(
        isHidden: Bool,
        btnTransform: CGAffineTransform,
        btnimage: UIImage?
    )
}

final class FloatingButtonView: UIView {
    
    // MARK: - 레이아웃
    // 플로팅 버튼 레이아웃
    private var floatingDimView: UIView = {
        let view = UIView.configureView(
            color: .backgroundGray)
        view.isHidden = true
        
        return view
    }()
    
    
    private var standardButton: UIButton = UIButton()

    
    private lazy var makeRoomScreenBtn: UIButton = UIButton.btnWithImg(
        image: .plus_Img,
        imageSize: 20,
        tintColor: UIColor.deep_Blue,
        backgroundColor: UIColor.normal_white,
        cornerRadius: self.smallButtonSize)
    private lazy var profileScreenBtn: UIButton = UIButton.btnWithImg(
        image: .person_Fill_Img,
        imageSize: 20,
        tintColor: UIColor.deep_Blue,
        backgroundColor: UIColor.normal_white,
        cornerRadius: self.smallButtonSize)
    
    private lazy var floatingStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.profileScreenBtn,
                           self.makeRoomScreenBtn],
        axis: .vertical,
        spacing: 5,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    // MARK: - 프로퍼티
    private var smallButtonSize: CGFloat { return 65 }
    private var BigButtonSize: CGFloat { return 80 }
    
    
    
    /// 플로팅 버튼의 배열
    private lazy var floatingArray: [UIButton] = [
        self.makeRoomScreenBtn,
        self.profileScreenBtn
    ]
    
    weak var delegate: FloatingButtonViewDelegate?
    /// 플로팅 버튼의 현재 상태
    private var isFloatingShow: Bool = false
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정
extension FloatingButtonView {
    /// UI 설정
    private func configureUI() {
        // 플로팅 버튼 배열 설정
        // 모서리 설정
        // 화면 밖으로 설정
        self.floatingArray.forEach { btn in
            btn.alpha = 0
            // 버튼을 화면 밖으로 위치시키기
            btn.transform = self.getBtnTransform
        }
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.standardButton)
        self.addSubview(self.floatingDimView)
        self.addSubview(self.floatingStackView)
        
        // 플로팅 버튼 백그라운드 화면
        self.floatingDimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 플로팅 버튼 스택뷰
        self.floatingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-27 - BigButtonSize)
            make.trailing.equalTo(
                -24
                 - (self.BigButtonSize / 2)
                 + (self.smallButtonSize / 2)
            )
        }
        // 플로팅 버튼 넓이 및 높이 설정
        self.makeRoomScreenBtn.snp.makeConstraints { make in
            make.width.height.equalTo(self.smallButtonSize)
        }
    }
    
    /// 액션 설정
    private func configureAction() {
        self.profileScreenBtn.addTarget(
            self,
            action: #selector(self.profileScreenBtnTapped),
            for: .touchUpInside)
        self.makeRoomScreenBtn.addTarget(
            self,
            action: #selector(self.makeRoomScreenBtnTapped),
            for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.toggleFloatingShow))
        self.floatingDimView.addGestureRecognizer(tapGesture)
    }
}










// MARK: - 액션 설정
extension FloatingButtonView {
    
    /// 프로필 액션 (사람 이미지 버튼)
    @objc private func profileScreenBtnTapped() {
        print(#function)
        self.delegate?.goToProfileScreen()
    }
    
    /// 방 생성 액션 (플러스 버튼)
    @objc private func makeRoomScreenBtnTapped() {
        print(#function)
        self.delegate?.goToRoomEditScreen()
    }
}










// MARK: - 플로팅 Spin 액션
extension FloatingButtonView {
    /// 플로팅 액션
    private func updateFloatingUI(type: floatingType) {
        // 플로팅 버튼 배경 설정
        self.configureFloatingDimView(type: type)
        // 플로팅 버튼 액션
        self.configureFloatingButtons(type: type)
    }
    
    /// 배경 (숨김/보임) 처리
    private func configureFloatingDimView(type: floatingType) {
        self.floatingDimView.isHidden = !type.show
        
        // 회색 배경 설정 및 메뉴 버튼 이미지 설정
        UIView.animate(withDuration: 0.3) {
            self.floatingDimView.alpha = type.alpha
        }
    }
    
    /// 버튼 (숨김/보임) 처리
    private func configureFloatingButtons(type: floatingType) {
        // 버튼 애니메이션
        let buttons = type.show
        ? self.floatingArray
        : self.floatingArray.reversed()
        
        for (index, button) in buttons.enumerated() {
            // 각 버튼마다 0.1초의 지연
            let delay = Double(index) * 0.1
            // 각 버튼을 순차적으로 작업
            UIView.animate(withDuration: 0.15, delay: delay) {
                button.transform = self.getBtnTransform
                button.alpha = type.alpha
                
            } completion: { _ in
                
                self.delegate?.floatingViewIsHidden(
                    isHidden: !type.show,
                    btnTransform: self.getSpinRotation,
                    btnimage: self.getMenuBtnImg
                )
            }
        }
    }
}










// MARK: - 플로팅 버튼
extension FloatingButtonView {
    /// 플로팅 버튼 토글
    @objc func toggleFloatingShow() {
        self.isFloatingShow.toggle()
        // 클로저 실행
        self.floatinBtnClosure()
    }
    
    /// 화면이 viewWillDisappear상태가 되면, 플로팅 버튼을 숨김
    func floatingViewIsHidden() {
        // 플로팅 버튼이 열려있다면,
        guard self.isFloatingShow else { return }
        // 플로팅 버튼 숨기기
        self.isFloatingShow = false
        // 클로저 실행
        self.floatinBtnClosure()
    }
    
    /// 플로팅 버튼 위치 변경
    private var getBtnTransform: CGAffineTransform {
        return self.isFloatingShow
        ? CGAffineTransform.identity
        : CGAffineTransform(translationX: 0, y: 80)
    }
    
    /// 메뉴 버튼 회전
    private var getSpinRotation: CGAffineTransform {
        return self.isFloatingShow
        ? CGAffineTransform(rotationAngle: .pi - (.pi / 4))
        : CGAffineTransform.identity
    }
    
    /// 메뉴 버튼 이미지
    private var getMenuBtnImg: UIImage? {
        return self.isFloatingShow
        ? UIImage.plus_Img
        : UIImage.menu_Img
    }
    
    
    
    /// 플로팅 클로저 실행
    private func floatinBtnClosure() {
        let show: Bool = self.getIsFloatingStatus
        let alpha: CGFloat = self.getBtnAlpha
        self.updateFloatingUI(type: (show, alpha))
    }
    /// 플로팅 버튼 Alpha
    private var getBtnAlpha: CGFloat {
        return self.isFloatingShow ? 1 : 0
    }
    
    /// 플로팅 버튼 상태 여부
    private var getIsFloatingStatus: Bool {
        return self.isFloatingShow
    }
}
