//
//  DefaultCell.swift
//  EveryDutch
//
//  Created by 계은성 on 5/1/24.
//

import UIKit

final class DefaultCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupCell()
    }

    private func setupCell() {
        self.backgroundColor = .red
        // 셀의 기본 설정
        self.textLabel?.textAlignment = .center
        self.textLabel?.textColor = .gray
    }
}
