//
//  CardImageView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/29.
//

import UIKit
import SnapKit

final class CardImageView: UIView {
    
    // MARK: - 레이아웃
    private var backgroundImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.medium_Blue
        return img
    }()
    private var titleLbl: CustomLabel = CustomLabel(
        font: .boldSystemFont(ofSize: 25))
    
    private var iconImg: UIImageView = UIImageView(
        image: UIImage(named: "DutchIcon"))
    
    private var arrowImg: UIImageView = UIImageView()
    
    private var lineView: UIView = UIView.configureView(
        color: UIColor.normal_white)
    
    private var nameLbl: CustomLabel = CustomLabel(
        textColor: .placeholder_gray,
        font: UIFont.systemFont(ofSize: 13))
    
    
    private var blurView: UIView = UIView.configureView(
        color: .white.withAlphaComponent(0.38))
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    // 데코레이션 모델, 초기화 시 해당 데이터 사용
    var originalDecorationData: Decoration?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정

extension CardImageView {
    
    // MARK: - UI 설정
    private func configureUI() {
        [self.backgroundImg, 
         self.blurView,
         self.iconImg].forEach { view in
            view.setRoundedCorners(.all, withCornerRadius: 10)
        }
        
        self.blurView.isHidden = true
        
        // MARK: - Fix
        self.titleLbl.text = "더치더치"
        self.nameLbl.text = "김게성성"
        
        self.arrowImg.image = UIImage.chevronLeft
        self.iconImg.backgroundColor = .normal_white
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.backgroundImg,
         self.arrowImg,
         self.titleLbl,
         self.iconImg,
         self.lineView,
         self.nameLbl,
         self.blurView].forEach { view in
            self.addSubview(view)
        }
        
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        self.arrowImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(-10)
            make.width.equalTo(10)
            make.height.equalTo(20)
        }
        self.iconImg.snp.makeConstraints { make in
            make.leading.equalTo(self.arrowImg.snp.trailing).offset(12)
            make.centerY.equalTo(self.arrowImg)
            make.width.height.equalTo(45)
        }
        self.lineView.snp.makeConstraints { make in
            make.top.equalTo(self.iconImg.snp.bottom).offset(10)
            make.leading.equalTo(self.iconImg.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(2)
        }
        self.nameLbl.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
//            make.leading.equalToSuperview().offset(20)
//            make.bottom.equalToSuperview().offset(-20)
        }
        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}










// MARK: - 데이터 초기화

extension CardImageView {
    func resetCardData(type: DecorationCellType) {
        switch type {
        case .background:
            print("1")
//            self.backgroundImg = self.originalDecorationData?.backgroundImage ??
//            self.backgroundColor = self.originalDecorationData?.backgroundColor ??
            break
        case .titleColor:
            print("2")
//            self.titleLbl.textColor = self.originalDecorationData?.titleColor ??
            break
        case .pointColor:
            print("3")
//            self.lineView.backgroundColor = self.originalDecorationData?.pointColor ??
//            self.nameLbl.textColor = self.originalDecorationData?.pointColor ??
            break
            
        // blurEffect는 여기서 처리하지 않음
        case .blurEffect: break
        }
    }
}










// MARK: - 초기 데이터 설정

extension CardImageView {
    
    // MARK: - [방]
    func setupRoomData(data roomData: Rooms) {
        self.titleLbl.text = roomData.roomName
        self.nameLbl.text = roomData.versionID
    }

    // MARK: - [유저]
    func setupUserData(data userData: User) {
        self.titleLbl.text = userData.userName
        self.nameLbl.text = userData.personalID
    }

    // MARK: - [데코]
    func setupDecorationData(data decorationData: Decoration) {
        self.blurView.isHidden = decorationData.blur
//        self.titleLbl.textColor = decorationData.titleColor
//        self.lineView.backgroundColor = decorationData.pointColor
//        self.nameLbl.textColor = decorationData.pointColor
//        self.backgroundImg.image = decorationData.backgroundImage
//        self.backgroundImg.backgroundColor = decorationData.backgroundImage
    }
}










// MARK: - [데코] 데이터 업데이트

extension CardImageView {
    
    // MARK: - 분기 처리
    func updateCardView(
        type: DecorationCellType,
        data: Any,
        onFailure: (ErrorEnum) -> Void)
    {
        // data 타입에 따른 분기 처리
        switch data {
        case let boolData as Bool:
            // Bool 타입 데이터 처리
            self.blurViewIsHidden(!boolData)
            
        case let colorData as UIColor:
            self.updateCardColor(type: type, color: colorData)
            
        case let imageData as UIImage:
            self.updateCardColor(type: type, image: imageData)
            
        default:
            onFailure(.unknownError)
        }
    }
    
    // MARK: - 블러 효과 변경
    private func blurViewIsHidden(_ isHidden: Bool) {
        self.blurView.isHidden.toggle()
    }
    
    // MARK: - 이미지 및 색상 변경
    private func updateCardColor(type: DecorationCellType,
                                 color: UIColor? = nil,
                                 image: UIImage? = nil) {
        switch type {
        case .titleColor:
            self.titleLbl.textColor = color
            
        case .pointColor:
            self.lineView.backgroundColor = color
            self.nameLbl.textColor = color

        case .background:
            self.backgroundImg.image = image
            self.backgroundImg.backgroundColor = color
            
        // blurEffect는 여기서 처리하지 않음
        case .blurEffect: break
        }
    }
}
