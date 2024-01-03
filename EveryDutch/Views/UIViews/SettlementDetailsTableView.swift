//
//  SettlementDetailsTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/27.
//

import UIKit
import SnapKit

final class SettlementDetailsTableView: UIView {
    
    // MARK: - 레이아웃
    private lazy var segmentedCtrl: CustomSegmentControl = CustomSegmentControl(
        items: ["누적 금액",
                "받아야 할 돈"])
    
    lazy var topViewTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            TopViewTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
        return view
    }()
    private lazy var topLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 15),
        textAlignment: .center)
    
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.topViewTableView],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    // MARK: - 프로퍼티
//    weak var delegate:
    private var customTableEnum : CustomTableEnum = .isSegmentCtrl
    
    // MARK: - 라이프사이클
    init(customTableEnum: CustomTableEnum) {
        self.customTableEnum = customTableEnum
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension SettlementDetailsTableView {
    
    
    private func configureUI() {
        switch self.customTableEnum {
        case .isLbl:
            self.stackView.insertArrangedSubview(self.topLbl, at: 0)
            
            self.topLbl.snp.makeConstraints { make in
                make.height.equalTo(34)
            }
            self.topLbl.clipsToBounds = true
            self.topLbl.layer.cornerRadius = 10
            
            break
        case .isReceipt:
            self.topViewTableView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner]
            fallthrough
        case .isSegmentCtrl:
            self.stackView.insertArrangedSubview(self.segmentedCtrl, at: 0)
            self.segmentedCtrl.snp.makeConstraints { make in
                make.height.equalTo(34)
            }
            break
        }
    }
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
        

        
        // MARK: - Fix
        self.topLbl.text = "누적 금액"
        self.topLbl.textAlignment = .center
        self.topLbl.backgroundColor =  .normal_white
    }
    private func configureAction() {
        // 세그먼트 컨트롤 - 액션
        self.segmentedCtrl.addTarget(self, action: #selector(self.valueChanged(segment:)), for: .valueChanged)
    }
    @objc private func valueChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            print("누적 금액")
            break
        case 1:
            print("받아야 할 돈")
            break
        default: break
        }
    }
}
// MARK: - 테이블뷰 델리게이트
extension SettlementDetailsTableView: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}

// MARK: - 테이블뷰 데이터 소스
extension SettlementDetailsTableView: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
//        return 30
        return 9
//        return 16
//        return 4
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.topViewTableView.dequeueReusableCell(withIdentifier: Identifier.topViewTableViewCell, for: indexPath) as! TopViewTableViewCell
        
        return cell
    }
}
