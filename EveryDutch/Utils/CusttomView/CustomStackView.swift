//
//  ProfileVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/30.
//

import UIKit
import SnapKit

final class CustomStackView: UIStackView {
    private var receiptImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    private var receiptDetailLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 13.5))
    
    lazy var receiptInfoLbl: CustomLabel = CustomLabel(
        font: UIFont.boldSystemFont(ofSize: 14),
        textAlignment: .right,
        leftInset: 10,
        rightInset: 10)
    
    
    private var receiptEnum: ReceiptEnum?
    private var addInfoLbl: Bool = false
    
    init(receiptEnum: ReceiptEnum,
         addInfoLbl: Bool = false) {
        self.receiptEnum = receiptEnum
        self.addInfoLbl = addInfoLbl
        super.init(frame: .zero)
        
        self.axis = .horizontal
        self.spacing = 7
        self.alignment = .center
        self.distribution = .fill
        self.configureCustomStackView()
        self.configureData()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCustomStackView() {
        self.addArrangedSubview(self.receiptImg)
        self.addArrangedSubview(self.receiptDetailLbl)
        if self.addInfoLbl {
            self.addArrangedSubview(self.receiptInfoLbl)
        }
        
        self.receiptImg.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        self.receiptDetailLbl.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }
    
    private func configureData() {
        self.receiptImg.image = self.receiptEnum?.img
        self.receiptDetailLbl.text = self.receiptEnum?.text
    }
    
//    func addViews(_ views: [UIView]) {
//        for view in views {
//            self.addArrangedSubview(view)
//        }
//    }
//    
//    func insertView(_ views: UIView,
//                    at: Int) {
//        
//    }
}
