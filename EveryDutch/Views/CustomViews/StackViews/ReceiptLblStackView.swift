//
//  ProfileVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/30.
//

import UIKit
import SnapKit

final class ReceiptLblStackView: UIStackView {
    
    private var imageContainerView: UIView = UIView.configureView(
        color: UIColor.clear)
    
    private var receiptImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    private var receiptDetailLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14))
    
    lazy var receiptInfoLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14),
        textAlignment: .right,
        leftInset: 10,
        rightInset: 10)
    
    
    private var receiptEnum: ReceiptCellEnum
    private var addInfoLbl: Bool = false
    
    init(receiptEnum: ReceiptCellEnum,
         addInfoLbl: Bool = false) {
        self.receiptEnum = receiptEnum
        self.addInfoLbl = addInfoLbl
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureCustomStackView()
        self.configureData()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.axis = .horizontal
        self.spacing = 8
        self.alignment = .center
        self.distribution = .fill
    }
    
    
    private func configureCustomStackView() {
        self.imageContainerView.addSubview(self.receiptImg)
        self.addArrangedSubview(self.imageContainerView)
        self.addArrangedSubview(self.receiptDetailLbl)
        if self.addInfoLbl {
            self.addArrangedSubview(self.receiptInfoLbl)
        }
        
        self.receiptImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(20)
        }
        self.receiptDetailLbl.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }
    
    private func configureData() {
        let cellData = self.receiptEnum.cellInfoTuple
        
        self.receiptImg.image = cellData.img
        self.receiptDetailLbl.text = cellData.text
    }
}
