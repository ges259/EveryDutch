//
//  CollectionViewCellVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

struct MainCollectionViewCellVM: MainCollectionViewCellVMProtocol {
    var title: String
//    var time_String: String
    var img_Url: String

    init(title: String,
//         time_String: String,
         imgUrl: String) {
        
        self.title = title
//        self.time_String = time_String
        self.img_Url = imgUrl
    }
    
    // 여기에 추가 뷰모델 로직 구현
}
