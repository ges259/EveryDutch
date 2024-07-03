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
    
    private var rightImageView: UIImageView = UIImageView()
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: ReceiptScreenPanUsersCellVMProtocol?
    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layer.cornerRadius = 0
    }
}

// MARK: - 화면 설정
extension ReceiptScreenUsersCell {
    /// UI 설정
    private func configureUI() {
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.backgroundColor = .normal_white
        
        self.rightImageView.tintColor = .black
    }
    
    func configureCell(with viewModel: ReceiptScreenPanUsersCellVMProtocol?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
        
        self.tableCellStackView.userNameLbl.text = viewModel.getUserName
        self.tableCellStackView.profileImg.image = viewModel.profileImg
        self.tableCellStackView.priceLbl.text = "\(viewModel.getPay)"
        self.rightImageView.image = viewModel.doneImg
        self.backgroundColor = viewModel.cellBackgroundColor
    }
    
    /// 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.tableCellStackView)
        self.contentView.addSubview(self.rightImageView)
        
        self.rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(21)
        }
        self.tableCellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.rightImageView.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}

