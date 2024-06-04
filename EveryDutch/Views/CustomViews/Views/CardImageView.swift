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
//        img.contentMode = .scaleAspectFit
        img.contentMode = .scaleAspectFill
        return img
    }()
    private var blurView: UIView = {
        let view = UIView.configureView(
            color: .white.withAlphaComponent(0.38))
        view.isHidden = true
        return view
    }()
    
    private var iconImg: UIImageView = UIImageView(
        image: UIImage(named: "DutchIcon"))
    
    private var arrowImg: UIImageView = UIImageView(image: UIImage.chevronLeft)
    
    private var lineView: UIView = UIView.configureView(
        color: UIColor.deep_Blue)
    
    
    private lazy var titleLbl: CustomLabel = CustomLabel(
        text: self.defaultText(for: 0),
        font: .boldSystemFont(ofSize: 25))
    private lazy var nameLbl: CustomLabel = CustomLabel(
        text: self.defaultText(for: 1),
        textColor: .placeholder_gray,
        font: UIFont.systemFont(ofSize: 13),
        textAlignment: .right)
    
    

    
    
    
    
    
    // MARK: - 프로퍼티
    // 데코레이션 모델, 초기화 시 해당 데이터 사용
    private var originalDecorationData: Decoration?
//    private var currentDecoration: Decoration?

    private var currentColorDict: [DecorationCellType: String] = [:]
    private var currentImageDict: [DecorationCellType: UIImage] = [:]
    
    
    
    
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
    /// UI 설정
    private func configureUI() {
        [self,
         self.blurView,
         self.iconImg].forEach { view in
            view.setRoundedCorners(.all, withCornerRadius: 10)
        }
        self.backgroundColor = .medium_Blue
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.backgroundImg,
         self.blurView,
         self.arrowImg,
         self.titleLbl,
         self.iconImg,
         self.lineView,
         self.nameLbl].forEach {
            self.addSubview($0)
        }
        // 배경 이미지
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 블러 뷰
        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 화살표 이미지
        self.arrowImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(-10)
            make.width.equalTo(10)
            make.height.equalTo(20)
        }
        // 아이콘 이미지
        self.iconImg.snp.makeConstraints { make in
            make.leading.equalTo(self.arrowImg.snp.trailing).offset(12)
            make.centerY.equalTo(self.arrowImg)
            make.width.height.equalTo(45)
        }
        // 라인 뷰
        self.lineView.snp.makeConstraints { make in
            make.top.equalTo(self.iconImg.snp.bottom).offset(10)
            make.leading.equalTo(self.iconImg.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(2)
        }
        
        // 타이틀 레이블
        self.titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        // 이름 레이블
        self.nameLbl.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
        }
    }
    /// EditScreenVM에서 Decoration데이터를 가져왔을 때,
    /// 해당 데이터를 저장 및 카드 이미지 변경
    func setupOriginalDecorationData(_ deco: Decoration?) {
        guard let deco = deco else { return }
        self.originalDecorationData = deco
        self.setupDecorationData(data: deco)
    }
}










// MARK: - 초기 데이터 설정
extension CardImageView {
    /// [방]
    func setupRoomData(data roomData: Rooms) {
        self.titleLbl.text = roomData.roomName
        self.nameLbl.text = roomData.versionID
    }
    
    /// [유저]
    func setupUserData(data userData: User) {
        self.titleLbl.text = userData.userName
        self.nameLbl.text = userData.personalID
    }
    
    /// [데코]
    func setupDecorationData(data decorationData: Decoration?) {
        guard let decorationData = decorationData else { return }
        self.blurView.isHidden = !decorationData.blur
        self.titleLbl.textColor = decorationData.getTitleColor
        self.nameLbl.textColor = decorationData.getNameColor
        self.backgroundImg.backgroundColor = decorationData.getBackgroundColor
        // MARK: - 이미지 설정
        self.backgroundImg.setImage(from: decorationData.backgroundImageUrl)
    }
}










// MARK: - 현재 데이터 저장
extension CardImageView {
    func saveCurrentData(type: DecorationCellType) {
        switch type {
        case .background:
            // 이미지라면
            if let image = self.backgroundImg.image {
                self.currentImageDict[.background] = image
                self.currentColorDict.removeAll()
                
            } else {
                self.currentColorDict[.background] = self.backgroundImg.backgroundColor?.toHexString()
                self.currentImageDict.removeAll()
            }
            break
        case .titleColor:
            self.currentColorDict[.titleColor] = self.titleLbl.textColor?.toHexString()
            break
        case .nameColor:
            self.currentColorDict[.nameColor] = self.nameLbl.textColor?.toHexString()
            break
        case .blurEffect:
            break
        }
    }
}










// MARK: - 데이터 리셋
extension CardImageView {
    func resetDecorationData(type: DecorationCellType) {
        // 기본 색상 가져오기
        let color = UIColor(hex: self.getCurrentColor(type: type),
                            defaultColor: type.getDefaultColor())
        
        switch type {
        case .background:
            if let currentImage = self.currentImageDict[.background] {
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
        case .blurEffect:
            break
        }
    }
    /// 현재 색상을 가져옴
    private func getCurrentColor(type: DecorationCellType) -> String? {
        let color = self.currentColorDict[type]
        
        switch type {
        case .background:
            return color ?? self.originalDecorationData?.backgroundColor
        case .titleColor:
            return color ?? self.originalDecorationData?.titleColor
        case .nameColor:
            return color ?? self.originalDecorationData?.nameColor
            
        case .blurEffect: return nil
        }
    }
}










// MARK: - [데이터] 데이터 업데이트
extension CardImageView {
    func updateDataCellText(index: Int, text: String) {
        let newText = text == ""
        ? self.defaultText(for: index)
        : text
        
        switch index {
        case 0: self.titleLbl.text = newText
        case 1: self.nameLbl.text = newText
        default:
            break
        }
    }
    
    private func defaultText(for index: Int) -> String {
        switch index {
        case 0:
            return "더치더치"
        case 1:
            return "DUTCH"
        default:
            return ""
        }
    }
}










// MARK: - [데코] 데이터 업데이트
extension CardImageView {
    /// 카드 업데이트 분기 처리
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
    
    /// 블러 효과 변경
    private func blurViewIsHidden(_ isHidden: Bool) {
        self.blurView.isHidden.toggle()
    }
    
    /// 이미지 및 색상 변경
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
