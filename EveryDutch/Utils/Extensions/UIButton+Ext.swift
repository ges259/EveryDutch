//
//  UIButton+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

extension UIButton {
    static func btnWithImg(imageEnum: imageEnum,
                           imageSize: CGFloat,
                           tintColor: UIColor = .black,
                           backgroundColor: UIColor? = UIColor.clear)
    -> UIButton {
        let btn = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: imageSize,
            weight: .light)
        let image = UIImage(systemName: imageEnum.img_String, withConfiguration: imageConfig)
            btn.setImage(image, for: .normal)
            btn.tintColor = tintColor
            btn.backgroundColor = backgroundColor
        return btn
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
    
    static func configureCircleBtn(size: CGFloat = 15,
                                   title: String,
                                   image: UIImage?)
    -> UIButton {
        var configuration = UIButton.Configuration.plain()
        
        // 타이틀 설정
        var titleContainer = AttributeContainer()
        // 폰트
        titleContainer.font = UIFont.systemFont(ofSize: 10)
        // 텍스트
        configuration.attributedTitle = AttributedString(
            title,
            attributes: titleContainer)
        
        // 이미지 설정
        configuration.image = image
        // 이미지 크기 설정
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: size)
        // 이미지 - 텍스트 사이 간격
        configuration.imagePadding = size == 15 ? 4 : 5
        // 이미지가 상단, 텍스트가 하단으로 설정
        configuration.imagePlacement = .top
        
        // 버튼 설정
        let btn = UIButton(configuration: configuration)
        btn.tintColor = UIColor.black
        btn.backgroundColor = UIColor.normal_white
        
        // 리턴
        return btn
    }
}
