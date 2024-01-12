//
//  ReceiptScreenTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit
import SnapKit

final class ReceiptScreenTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var profileImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    private var userName: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 14))
    
    private var priceLbl: CustomLabel = CustomLabel(
        backgroundColor: .medium_Blue,
        topBottomInset: 4,
        leftInset: 10,
        rightInset: 10)
    
    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        image: .check_Square_Img,
        imageSize: 13)
    
    private lazy var leftStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.profileImg,
                           self.userName,
                           self.priceLbl],
        axis: .horizontal,
        spacing: 8,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: ReceiptScreenPanCellVM?
    
    var isToggle: Bool = false
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureClosure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension ReceiptScreenTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        self.separatorInset = .zero
        
        self.priceLbl.clipsToBounds = true
        self.priceLbl.layer.cornerRadius = 10
    }
    
    func configureCell(with viewModel: ReceiptScreenPanCellVM) {
        self.viewModel = viewModel
        
        self.userName.text = viewModel.userName
        self.profileImg.image = viewModel.profileImg
        self.priceLbl.text = "\(viewModel.pay)"
        self.rightBtn.setImage(viewModel.doneImg, for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.leftStackView)
        self.contentView.addSubview(self.rightBtn)
        
        
        self.profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        self.priceLbl.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        self.userName.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        self.rightBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(21)
        }
        self.leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.rightBtn.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.rightBtn.addTarget(
            self, 
            action: #selector(self.rightBtnTapped),
            for: .touchUpInside)
    }
    
    private func configureClosure() {
        self.viewModel?.doneStatusChanged = { img in
            self.rightBtn.setImage(img, for: .normal)
        }
    }
    
    @objc private func rightBtnTapped() {
        self.viewModel?.done.toggle()
    }
}
