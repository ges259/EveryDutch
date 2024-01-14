//
//  ReceiptWriteTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 1/13/24.
//

import UIKit

final class ReceiptWriteTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var tableCellStackView: TableCellStackView = TableCellStackView(
        rightImgInStackView: false)
    
    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        image: .x_Mark_Img,
        imageSize: 13)
    
    lazy var priceTf: InsetTextField = {
        let tf =  InsetTextField(
            backgroundColor: UIColor.medium_Blue,
            placeholerColor: .placeholder_gray,
            placeholderText: "가격 입력")
        tf.isHidden = true
        return tf
    }()
    
    
    // MARK: - 프로퍼티
    var viewModel: ReceiptWriteCellVM?
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, 
                   reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool,
                              animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.priceTf.isHidden = false
        } else {
            self.priceTf.isHidden = true
        }
    }
}

// MARK: - 화면 설정

extension ReceiptWriteTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
        
        self.priceTf.layer.maskedCorners = [
            .layerMinXMinYCorner, // 좌상단
            .layerMinXMaxYCorner] // 좌하단
        
        self.priceTf.clipsToBounds = true
        self.priceTf.layer.cornerRadius = 10
    }
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.tableCellStackView)
        self.contentView.addSubview(self.rightBtn)
        self.contentView.addSubview(self.priceTf)
        
        self.rightBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(21)
        }
        self.tableCellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.rightBtn.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        self.priceTf.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(self.frame.width / 2)
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
        self.rightBtn.addTarget(
            self,
            action: #selector(self.rightBtnTapped),
            for: .touchUpInside)
    }
    
    
    
    func configureCell(with viewModel: ReceiptWriteCellVM) {
        self.viewModel = viewModel
        
        self.tableCellStackView.userNameLbl.text = viewModel.userName
        self.tableCellStackView.profileImg.image = viewModel.profileImg
        self.tableCellStackView.priceLbl.text = "0"
    }
    
    
    @objc private func rightBtnTapped() {
//        self.viewModel?.done.toggle()
        print(#function)
    }
}
