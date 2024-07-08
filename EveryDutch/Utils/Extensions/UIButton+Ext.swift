//
//  UIButton+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

extension UIButton {
    static func btnWithImg(image: UIImage?,
                           imageSize: CGFloat = 15,
                           tintColor: UIColor = .black,
                           imagePadding: CGFloat = 6,
                           backgroundColor: UIColor? = UIColor.normal_white,
                           title: String? = nil,
                           cornerRadius: CGFloat = 0)
    -> UIButton {
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        configuration.image = image
        // 이미지 크기 설정
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: imageSize)
        
        
        // 타이틀 설정
        if let title = title {
            var titleContainer = AttributeContainer()
            // 폰트
            titleContainer.font = UIFont.boldSystemFont(ofSize: 12)
            // 텍스트
            configuration.attributedTitle = AttributedString(
                title,
                attributes: titleContainer)
            // 이미지 - 텍스트 사이 간격
            configuration.imagePadding = imagePadding
            // 이미지가 상단, 텍스트가 하단으로 설정
            configuration.imagePlacement = .top
        }
        
        
        let btn = UIButton(configuration: configuration)
        if cornerRadius != 0 {
            btn.setRoundedCorners(.all, withCornerRadius: cornerRadius / 2)
        }
            btn.tintColor = tintColor
            btn.backgroundColor = backgroundColor
        return btn
    }
    func imageAndTitleFix(image: UIImage?, title: String, imageSize: CGFloat = 15, imagePadding: CGFloat = 6) {
        // 기존 configuration을 가져오거나 새로 생성
        var newConfiguration = self.configuration ?? UIButton.Configuration.plain()
        
        // 이미지 설정
        newConfiguration.image = image
        newConfiguration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: imageSize)
        
        // 타이틀 설정
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 12)
        newConfiguration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        // 이미지와 텍스트 사이 간격 설정
        newConfiguration.imagePadding = imagePadding
        
        // 업데이트된 configuration을 self에 적용
        self.configuration = newConfiguration
    }
    
    static func btnWithTitle(title: String = "",
                             titleColor: UIColor = UIColor.black,
                             font: UIFont,
                             backgroundColor: UIColor)
    -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = font
        btn.backgroundColor = backgroundColor
        return btn
    }
    
//    static func configureCircleBtn(size: CGFloat = 15,
//                                   title: String,
//                                   image: UIImage?)
//    -> UIButton {
//        var configuration = UIButton.Configuration.plain()
//        // 이미지 설정
//        configuration.image = image
//        // 이미지 크기 설정
//        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: size)
//        
//        
//        
//        // 타이틀 설정
//        var titleContainer = AttributeContainer()
//        // 폰트
//        titleContainer.font = UIFont.systemFont(ofSize: 10)
//        // 텍스트
//        configuration.attributedTitle = AttributedString(
//            title,
//            attributes: titleContainer)
//        // 이미지 - 텍스트 사이 간격
//        configuration.imagePadding = size == 15 ? 4 : 5
//        // 이미지가 상단, 텍스트가 하단으로 설정
//        configuration.imagePlacement = .top
//        
//        // 버튼 설정
//        let btn = UIButton(configuration: configuration)
//        btn.tintColor = UIColor.black
//        btn.backgroundColor = UIColor.normal_white
//        
//        // 리턴
//        return btn
//    }
//    
    
    
    
    
    
    
}
