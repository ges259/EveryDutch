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
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
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
    
    static func configureCircleBtn(size: CGFloat = 13,
                                   title: String,
                                   image: UIImage?)
    -> UIButton {
        var configuration = UIButton.Configuration.plain()
        
        // 타이틀 설정
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 8)
        configuration.attributedTitle = AttributedString(
            title,
            attributes: titleContainer)
        
        // 이미지 설정
        configuration.image = image
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: size)
        configuration.imagePadding = 4
        // 이미지가 상단에 위치한 버튼
        configuration.imagePlacement = .top
        
        // 버튼 설정
        let btn = UIButton(configuration: configuration)
        btn.tintColor = UIColor.black
        btn.backgroundColor = UIColor.normal_white
        
        // 리턴
        return btn
    }
}
