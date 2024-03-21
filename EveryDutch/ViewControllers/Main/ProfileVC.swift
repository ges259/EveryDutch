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
    
    
    
    private lazy var tableView: CustomTableView = {
        let view = CustomTableView()
        view.register(
            ProfileCell.self,
            forCellReuseIdentifier: Identifier.profileTableViewCell)
        
        view.sectionHeaderTopPadding = 12
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        return view
    }()
    
    
    private lazy var totalStackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.cardImgView,
                           self.tableView],
        axis: .vertical,
        spacing: 0,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: ProfileVMProtocol
    private let coordinator: ProfileCoordProtocol
    
    
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.viewModel.initializeUserData()
    }
    init(viewModel: ProfileVMProtocol,
         coordinator: ProfileCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("\(#function)-----\(self)")
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
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 버튼 생성
        let backButton = UIBarButtonItem(
            image: .chevronLeft,
            style: .done,
            target: self,
            action: #selector(self.backButtonTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.leftBarButtonItem = backButton
        
        let rightBtn = UIBarButtonItem(
            image: .gear_Fill_Img,
            style: .done,
            target: self,
            action: #selector(self.rigntBtnTapped))
        // 네비게이션 바의 왼쪽 아이템으로 설정
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    // MARK: - 클로저 설절
    private func configureClosure() {
        self.viewModel.userDataClosure = { [weak self] userData in
            self?.dataChange(data: userData)
        }
        self.viewModel.errorClosure = { [weak self] errorType in
            self?.errorType(errorType)
        }
    }
}










// MARK: - 액션 설정

extension ProfileVC {
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
    @objc private func rigntBtnTapped() {
        self.coordinator.editScreen()
    }
    
    
    private func dataChange(data: User) {
        self.cardImgView.configureUserData(data: data)
    }
    private func errorType(_ errorType: ErrorEnum) {
        
    }
}










// MARK: - 테이블뷰 델리게이트

extension ProfileVC: UITableViewDelegate {
    
    // MARK: - 셀의 높이
    /// 셀의 높이를 설정합니다.
    func tableView(_ tableView: UITableView, 
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 50
    }
    
    // MARK: - 헤더뷰 설정
    /// 헤더 뷰를 구성합니다.
    func tableView(_ tableView: UITableView, 
                   viewForHeaderInSection section: Int)
    -> UIView? {
        return self.createHeaderView(for: section)
    }
    
    // MARK: - 헤더 높이
    /// 헤더의 높이를 설정합니다.
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int)
    -> CGFloat {
        return 70
    }
    
    // MARK: - 푸터뷰 설정
    /// 푸터 뷰를 구성합니다. 특정 조건을 만족하는 섹션에만 푸터를 설정합니다.
    func tableView(_ tableView: UITableView, 
                   viewForFooterInSection section: Int)
    -> UIView? {
        return self.createFooterView()
    }
    
    // MARK: - 푸터뷰 높이
    /// 푸터의 높이를 설정합니다. 특정 조건을 만족할 때만 높이를 할당합니다.
    func tableView(_ tableView: UITableView, 
                   heightForFooterInSection section: Int)
    -> CGFloat {
        return self.viewModel.getFooterViewHeight(section: section)
    }
    
    
    
    
    
// MARK: - Helper_Functions
    
    
    
    // MARK: - 헤더뷰 생성
    /// 헤더 뷰를 생성합니다.
    private func createHeaderView(for section: Int) -> UIView {
        let title = self.viewModel.getHeaderTitle(section: section)
        return TableHeaderView(
            title: title,
            tableHeaderEnum: .profileVC)
    }
    // MARK: - 푸터뷰 생성
    private func createFooterView() -> UIView {
        return TableFooterView()
    }
}










// MARK: - 테이블뷰 데이터소스

extension ProfileVC: UITableViewDataSource {
    
    // MARK: - 섹션 수
    // 테이블 뷰의 섹션 수를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getNumOfSection
    }
    
    // MARK: - 셀의 개수
    // 각 섹션의 행 수를 반환
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int)
    -> Int {
        return self.viewModel.getNumOfCell(
            section: section)
    }
    
    // MARK: - 셀 구성
    // 셀을 구성하는 함수
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.profileTableViewCell,
            for: indexPath) as! ProfileCell
        
        let tableData = self.viewModel.getTableData(
            section: indexPath.section,
            index: indexPath.row)
        cell.configureCell(tableData)
        return cell
    }
}
