//
//  ProfileVC.swift
//  EveryDutch
//
//  Created by 계은성 on 1/31/24.
//

import UIKit
import SnapKit

final class ProfileVC: UIViewController {
    
    // MARK: - 레이아웃
    /// 스크롤뷰
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private var contentView: UIView = UIView()
    
    private var cardImgView: CardImageView = CardImageView()
    
    
    
    private lazy var tableVeiw: CustomTableView = {
        let view = CustomTableView()
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: Identifier.profileTableViewCell)
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        return view
    }()
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.cardImgView,
                           self.tableVeiw],
        axis: .vertical,
        spacing: 12,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    // MARK: - 프로퍼티
    let section: [ProfileVCEnum] = [.userInfo, .others]
    
    
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
}










// MARK: - 화면 설정

extension ProfileVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = .base_Blue
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.totalStackView)
        
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        
        // 카드 이미지 뷰
        self.cardImgView.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight)
        }
        
        
        // 스택뷰
        self.totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-UIDevice.current.bottomBtnHeight - 10)
        }
        
        
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}










// MARK: - 테이블뷰 델리게이트

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    /// 헤더의 높이 설정
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int)
    -> CGFloat {
        return 70
    }
    /// 셀의 모서리 설정 (마지막 셀만 설정)
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        guard !self.checkHeight(section: section) else { return }
        
        // Reset corners
        cell.contentView.layer.cornerRadius = 0
        cell.contentView.layer.maskedCorners = []

        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner]
            cell.contentView.layer.masksToBounds = true
        }
    }
    
    
    ///
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.contentView.layer.cornerRadius = 0
    }
    
    /// 헤더 설정
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int)
    -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.medium_Blue // 원하는 색상으로 변경하세요.
        
        let headerLabel = CustomLabel(
            text: self.section[section].title,
            textColor: UIColor.black,
            font: UIFont.boldSystemFont(ofSize: 25))
        
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        // 상단 모서리에만 cornerRadius 적용
        headerView.layer.cornerRadius = 10
        headerView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        
        return headerView
    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int)
    -> UIView? {
        guard self.checkHeight(section: section) else { return nil }
        
        // 푸터 뷰를 커스텀 뷰로 생성합니다.
        let footerView = UIView()
        footerView.backgroundColor = UIColor.medium_Blue
        // 상단 모서리에만 cornerRadius 적용
        footerView.layer.cornerRadius = 10
        footerView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner]
        footerView.clipsToBounds = true
        return footerView
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int)
    -> CGFloat {
        return self.checkHeight(section: section)
        ? 50 // 섹션 콘텐츠의 총 높이가 최소 높이보다 크거나 같은 경우, 기본 푸터 높이를 반환
        : 0 // 푸터 뷰를 보이지 않게 하기 위한 최소값
    }
    
    private func checkHeight(section: Int) -> Bool {
        // 푸터 높이를 계산하여 최소 높이를 충족시킵니다.
        let sectionData = self.section[section].tableData
        let numberOfRows = sectionData?.count ?? 0
        // 섹션 콘텐츠의 총 높이가 cardHeight 미만인 경우, 푸터 높이를 조정합니다.
        return numberOfRows <= 3
    }
}

// MARK: - 테이블뷰 데이터소스

extension ProfileVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int)
    -> Int {
        let sectionType = self.section[section]
        
        return sectionType.tableData?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.profileTableViewCell,
            for: indexPath) as! ProfileTableViewCell
        
        
        let sectionType = self.section[indexPath.section]
        
        if let tableData = sectionType.tableData {
             let key = Array(tableData.keys)[indexPath.row]
             cell.detailLbl.text = key
             cell.infoLbl.text = tableData[key]
         }
        
        return cell
    }
    func tableView(_ tableView: UITableView, 
                   titleForHeaderInSection section: Int)
    -> String? {
        return self.section[section].title
    }
}










final class ProfileTableViewCell: UITableViewCell {
    
    
    var detailLbl: CustomLabel = CustomLabel(
        leftInset: 26)
    
    var infoLbl: CustomLabel = CustomLabel(
        textAlignment: .right,
        rightInset: 26)
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear // 셀의 배경을 투명하게 설정합니다.
        self.contentView.backgroundColor = .medium_Blue // contentView에 색상을 지정합니다.
        
        self.clipsToBounds = true
        
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        
    }
    private func configureAutoLayout() {
        self.addSubview(self.detailLbl)
        self.addSubview(self.infoLbl)
        
        self.detailLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        // 기존의 configureAutoLayout() 메서드 내부의 infoLbl 제약 조건을 수정합니다.
        self.infoLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
