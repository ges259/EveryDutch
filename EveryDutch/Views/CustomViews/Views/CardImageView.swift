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
    
    private var arrowImg: UIImageView = UIImageView(image: UIImage.chevronLeft)
    
    private var lineView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    private var nameLbl: CustomLabel = CustomLabel(
        textColor: .placeholder_gray,
        font: UIFont.systemFont(ofSize: 13))
    
    
    private var blurView: UIView = {
        let view = UIView.configureView(
            color: .white.withAlphaComponent(0.38))
        view.isHidden = true
        return view
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    // 데코레이션 모델, 초기화 시 해당 데이터 사용
    var originalDecorationData: Decoration?
    
    var currentColorDict: [String: String] = [:] {
        didSet {
            dump(self.currentColorDict)
        }
    }
    var currentImageDict: [String: UIImage] = [:] {
        didSet {
            dump(self.currentImageDict)
        }
    }
    
    
    
    
    
    
    
    
    
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
        [self,
         self.blurView,
         self.iconImg].forEach { view in
            view.setRoundedCorners(.all, withCornerRadius: 10)
        }
        self.backgroundColor = .medium_Blue
        // MARK: - Fix
        self.titleLbl.text = "더치더치"
        self.nameLbl.text = "DUCTCH"
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.backgroundImg,
         self.blurView,
         self.arrowImg,
         self.titleLbl,
         self.iconImg,
         self.lineView,
         self.nameLbl].forEach { view in
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
        }
        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        self.titleLbl.textColor = decorationData.getTitleColor
        self.nameLbl.textColor = decorationData.getNameColor
        // MARK: - 이미지 설정
//        self.backgroundImg.image = decorationData.
        self.backgroundImg.backgroundColor = decorationData.getBackgroundColor
    }
}










// MARK: - 현재 데이터 저장
extension CardImageView {
    func saveCurrentData(type: DecorationCellType) {
        switch type {
        case .background:
            if let image = self.backgroundImg.image {
                self.currentImageDict[DatabaseConstants.background_Image] = image
                self.currentColorDict.removeValue(forKey: DatabaseConstants.background_Color)
            } else {
                self.currentColorDict[DatabaseConstants.background_Color] = self.backgroundImg.backgroundColor?.toHexString()
                self.currentImageDict.removeValue(forKey: DatabaseConstants.background_Image)
            }
            break
        case .titleColor:
            self.currentColorDict[DatabaseConstants.title_Color] = self.titleLbl.textColor?.toHexString()
            break
        case .nameColor:
            self.currentColorDict[DatabaseConstants.name_Color] = self.nameLbl.textColor?.toHexString()
            break
        case .blurEffect:
            break
        }
    }
}










// MARK: - 데이터 리셋
extension CardImageView {
    func resetDecorationData(type: DecorationCellType) {
        
        let color = UIColor(hex: self.getCurrentColor(type: type),
                            defaultColor: self.getDefaultColor(type: type))
        switch type {
        case .background:
            if let currentImage = self.currentImageDict[DatabaseConstants.background_Image] {
                self.backgroundImg.image = currentImage
                self.backgroundImg.backgroundColor = nil
            } else {
                self.backgroundImg.backgroundColor = color
                self.backgroundImg.image = nil
            }
            break
            
        case .titleColor:
            self.titleLbl.textColor = color
            break
            
        case .nameColor:
            self.nameLbl.textColor = color
            break
            
        // blurEffect는 여기서 처리하지 않음
        case .blurEffect: break
        }
    }
    /// 현재 색상을 가져옴
    private func getCurrentColor(type: DecorationCellType) -> String? {
        switch type {
        case .background:
            return self.currentColorDict[DatabaseConstants.background_Color] ?? self.originalDecorationData?.backgroundColor
        case .titleColor:
            return self.currentColorDict[DatabaseConstants.title_Color] ?? self.originalDecorationData?.titleColor
        case .nameColor:
            return self.currentColorDict[DatabaseConstants.name_Color] ?? self.originalDecorationData?.nameColor
            
        case .blurEffect: return nil
        }
    }
    /// 기본 색상을 가져옴
    private func getDefaultColor(type: DecorationCellType) -> UIColor {
        switch type {
        case .background:
            return .medium_Blue
        case .titleColor:
            return .black
        case .nameColor:
            return .placeholder_gray
        case .blurEffect:
            return .clear
        }
    }
}










// MARK: - [데이터] 데이터 업데이트
extension CardImageView {
    func updateDataCellText(indexPath: Int, text: String?) {
        switch indexPath {
        case 0:
            self.titleLbl.text = text
            break
            
        case 1: self.nameLbl.text = text
            break
            
        default:
            break
        }
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
            self.changeCardData(type: type, color: colorData)
            
        case let imageData as UIImage:
            self.changeCardData(type: type, image: imageData)
            
        default:
            onFailure(.unknownError)
        }
    }
    
    // MARK: - 블러 효과 변경
    private func blurViewIsHidden(_ isHidden: Bool) {
        self.blurView.isHidden.toggle()
    }
    
    // MARK: - 이미지 및 색상 변경
    private func changeCardData(type: DecorationCellType,
                                color: UIColor? = nil,
                                image: UIImage? = nil) {
        switch type {
        case .titleColor:
            self.titleLbl.textColor = color
            
        case .nameColor:
            self.nameLbl.textColor = color

        case .background:
            self.backgroundImg.image = image
            self.backgroundImg.backgroundColor = color
            
        // blurEffect는 여기서 처리하지 않음
        case .blurEffect: break
        }
    }
}
