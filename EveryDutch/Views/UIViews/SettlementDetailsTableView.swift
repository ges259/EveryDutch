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
    private var firstBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.normal_white)
    
    private var secondBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.systemFont(ofSize: 14),
        backgroundColor: UIColor.unselected_gray)
    
    private lazy var btnStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.firstBtn,
                           self.secondBtn],
        axis: .horizontal,
        spacing: 0,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    lazy var topViewTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            TopViewTableViewCell.self,
            forCellReuseIdentifier: Identifier.topViewTableViewCell)
        return view
    }()
    private lazy var topLbl: CustomLabel = CustomLabel(
        font: UIFont.systemFont(ofSize: 15),
        textAlignment: .center)
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.topViewTableView],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    // MARK: - 프로퍼티
//    weak var delegate:
    private var customTableEnum : CustomTableEnum = .isSegmentCtrl
    
    private var isFirstBtnTapped: Bool = false {
        didSet {
            self.btnChanged()
        }
    }
    
    
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
            self.isLbl()
            self.configureLbl()
            break
            
        case .isSegmentCtrl: 
            self.isSegmentCtrl()
            self.configureSegmentCtrl()
            break
            
        case .isReceiptWrite: 
            self.isReceiptWrite()
            self.configureSegmentCtrl()
            break
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.totalStackView)
        
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        
        // MARK: - Fix
        self.topLbl.text = "누적 금액"
        self.firstBtn.setTitle("누적 금액", for: .normal)
        self.secondBtn.setTitle("받아야 할 돈", for: .normal)
        self.topLbl.backgroundColor =  .normal_white
    }
    private func configureAction() {
        // 세그먼트 컨트롤 - 액션
        self.firstBtn.addTarget(self, action: #selector(self.firstBtnTapped), for: .touchUpInside)
        self.secondBtn.addTarget(self, action: #selector(self.secondBtnTapped), for: .touchUpInside)
    }
    
    
    
    
    
    
    @objc private func firstBtnTapped() {
        self.isFirstBtnTapped = true
        
    }
    @objc private func secondBtnTapped() {
        self.isFirstBtnTapped = false
        
    }
    
    private func btnChanged() {
        // MARK: - Fix - ViewModel
        if self.isFirstBtnTapped {
            self.firstBtn.backgroundColor = UIColor.normal_white
            self.secondBtn.backgroundColor = UIColor.unselected_gray
        } else {
            self.firstBtn.backgroundColor = UIColor.unselected_gray
            self.secondBtn.backgroundColor = UIColor.normal_white
        }
    }
    
    
    
    private func isLbl() {
        
    }
    private func isReceiptWrite() {
        
    }
    private func isSegmentCtrl() {
        // 모서리 설정 (상단)
        self.topViewTableView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        self.topViewTableView.clipsToBounds = true
        self.topViewTableView.layer.cornerRadius = 10
        
        
    }
    
    
    
    private func configureLbl() {
        self.totalStackView.insertArrangedSubview(self.topLbl, at: 0)
        
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        self.topLbl.clipsToBounds = true
        self.topLbl.layer.cornerRadius = 10
        self.topViewTableView.clipsToBounds = true
        self.topViewTableView.layer.cornerRadius = 10
    }
    
    private func configureSegmentCtrl() {
        self.totalStackView.insertArrangedSubview(self.btnStackView, at: 0)
        self.totalStackView.setCustomSpacing(0, after: self.btnStackView)
        self.btnStackView.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        
        self.firstBtn.layer.maskedCorners = [.layerMinXMinYCorner]
        self.secondBtn.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        self.firstBtn.layer.cornerRadius = 10
        self.secondBtn.layer.cornerRadius = 10
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
//        return 9
//        return 16
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.topViewTableView.dequeueReusableCell(withIdentifier: Identifier.topViewTableViewCell, for: indexPath) as! TopViewTableViewCell
        
        return cell
    }
}
