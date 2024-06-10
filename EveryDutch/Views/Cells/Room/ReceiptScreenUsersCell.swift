//
//  ReceiptScreenTableViewCell.swift
//  EveryDutch
//
//  Created by 계은성 on 1/12/24.
//

import UIKit
import SnapKit

final class ReceiptScreenUsersCell: UITableViewCell {
    
    // MARK: - 레이아웃
    private var tableCellStackView: TableCellStackView = TableCellStackView()
    
    private lazy var rightBtn: UIButton = UIButton.btnWithImg(
        image: .check_Square_Img,
        imageSize: 13)
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: ReceiptScreenPanUsersCellVMProtocol?
    
    
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

extension ReceiptScreenUsersCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .normal_white
    }
    
    func configureCell(with viewModel: ReceiptScreenPanUsersCellVMProtocol) {
        self.viewModel = viewModel
        
        self.tableCellStackView.userNameLbl.text = viewModel.getUserName
        self.tableCellStackView.profileImg.image = viewModel.profileImg
        self.tableCellStackView.priceLbl.text = "\(viewModel.getPay)"
        self.rightBtn.setImage(viewModel.doneImg, for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.tableCellStackView)
        self.contentView.addSubview(self.rightBtn)
        
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
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.rightBtn.addTarget(
            self, 
            action: #selector(self.rightBtnTapped),
            for: .touchUpInside)
    }
    
    // MARK: - 클로저 설정
    private func configureClosure() {
        self.viewModel?.doneStatusChanged = { [weak self] img in
            self?.rightBtn.setImage(img, for: .normal)
        }
    }
    
    
    
    
    
    // MARK: - 오른쪽 버튼 액션
    @objc private func rightBtnTapped() {
        self.viewModel?.changeDoneValue(true)
    }
}

