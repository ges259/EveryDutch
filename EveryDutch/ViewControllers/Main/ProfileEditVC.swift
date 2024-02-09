//
//  SettingVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit
import SnapKit

final class ProfileEditVC: UIViewController {
    
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
    
    // MARK: - 테이블뷰
    private lazy var tableView: CustomTableView = {
        let view = CustomTableView()
        view.register(
            CardDataCell.self,
            forCellReuseIdentifier: Identifier.cardDataCell)
        view.register(
            CardDecorationCell.self,
            forCellReuseIdentifier: Identifier.cardDecorationCell)
        
        view.sectionHeaderTopPadding = 12
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    
    
    private var clearView: UIView = UIView()
    
    
    private var bottomBtn: BottomButton = BottomButton(
        title: "완료")
    
    
    private var profileChangeBtn: UIButton = UIButton.btnWithTitle(
        title: "프로필 이미지 설정",
        font: UIFont.boldSystemFont(ofSize: 14),
        backgroundColor: .deep_Blue)
    
    private var backgroundChangeBtn: UIButton = UIButton.btnWithTitle(
        title: "배경 이미지 설정",
        font: UIFont.boldSystemFont(ofSize: 14),
        backgroundColor: .deep_Blue)
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var viewModel: ProfileEditVMProtocol
    private var coordinator: ProfileEditVCCoordProtocol
    /// CardScreenCoordinator로 전달 됨
    weak var delegate: CardScreenDelegate?
    
    
    
    private lazy var cardHeight = (self.view.frame.width - 20) * 1.8 / 3
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(viewModel: ProfileEditVMProtocol,
         coordinator: ProfileEditVCCoordProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정

extension ProfileEditVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.base_Blue
        
        self.tableView.addShadow(shadowType: .card)
        
        self.profileChangeBtn.setRoundedCorners(.bottom, withCornerRadius: 12)
        self.backgroundChangeBtn.setRoundedCorners(.bottom, withCornerRadius: 12)
        
        
        let btnTitle = self.viewModel.bottomBtn_Title
        self.bottomBtn.setTitle(btnTitle, for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.cardImgView)
        self.contentView.addSubview(self.tableView)
        self.view.addSubview(self.bottomBtn)
        
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
        self.cardImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        // 테이블뷰
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.cardImgView.snp.bottom)
            make.leading.trailing.equalTo(self.cardImgView)
            make.bottom.equalToSuperview().offset(-UIDevice.current.bottomBtnHeight - 10)
        }
        
        // 바텀뷰
        self.bottomBtn.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.current.bottomBtnHeight)
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
    }
}










// MARK: - 액션 메서드
extension ProfileEditVC {
    @objc private func backButtonTapped() {
        self.coordinator.didFinish()
    }
}










// MARK: - 테이블뷰 델리게이트

extension ProfileEditVC: UITableViewDelegate {
    
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
        return section == 1
        ? self.backgroundChangeBtn
        : self.profileChangeBtn
    }
    
    // MARK: - 푸터뷰 높이
    /// 푸터의 높이를 설정합니다. 특정 조건을 만족할 때만 높이를 할당합니다.
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int)
    -> CGFloat {
        return 50
    }
    
    
    
    
    
// MARK: - Helper_Functions
    
    
    
    // MARK: - 헤더뷰 생성
    /// 헤더 뷰를 생성합니다.
    private func createHeaderView(for section: Int) -> UIView {
        let title = self.viewModel.getHeaderTitle(
            section: section)
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

extension ProfileEditVC: UITableViewDataSource {
    
    // MARK: - 섹션 수
    // 테이블 뷰의 섹션 수를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getNumOfSection
    }
    
    // MARK: - 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) 
    -> Int {
        return self.viewModel.getNumOfCell(
            section: section)
    }
    
    // MARK: - 셀 구성
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Identifier.cardDecorationCell,
                for: indexPath) as! CardDecorationCell
            
            
            let text = self.viewModel.getTableData(
                section: indexPath.section,
                index: indexPath.row)
            cell.setDetailLbl(text: text)
            
            return cell
            
            
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Identifier.cardDataCell,
                for: indexPath) as! CardDataCell
            // 첫 번째 셀이라면, 오른쪽 상단 모서리 설정
            if indexPath.row == 0 {
                self.firstCellSetCorner(cell: cell)
            }
            
            let text = self.viewModel.getTableData(
                section: indexPath.section,
                index: indexPath.row)
            cell.setDetailLbl(text: text)
            
            return cell
        }
    }
    
    
    // MARK: - 셀의 모서리 설정
    private func firstCellSetCorner(cell: CardDataCell) {
        cell.textField.setRoundedCorners(.leftTop, withCornerRadius: 12)
    }
}
