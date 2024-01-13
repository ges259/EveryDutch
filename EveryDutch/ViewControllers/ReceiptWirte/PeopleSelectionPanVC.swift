//
//  PeopleSelectionPanVC.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/03.
//

import UIKit
import SnapKit
import PanModal

final class PeopleSelectionPanVC: UIViewController {
    // MARK: - 레이아웃
    private var topLbl: CustomLabel = CustomLabel(
        font: UIFont.boldSystemFont(ofSize: 15),
        backgroundColor: UIColor.normal_white,
        textAlignment: .center)
    
    
    private lazy var peopleSelectionTableView: CustomTableView = {
        let view = CustomTableView()
        view.delegate = self
        view.dataSource = self
        view.register(
            PeopleSelectionPanCell.self,
            forCellReuseIdentifier: Identifier.peopleSelectionPanCell)
        return view
    }()
    
    
    private var bottomBtn: UIButton = UIButton.btnWithTitle(
        font: UIFont.boldSystemFont(ofSize: 16),
        backgroundColor: UIColor.normal_white)
    
    
    
    
    
    private lazy var stackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.topLbl,
                           self.peopleSelectionTableView,
                           self.bottomBtn],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    // MARK: - 프로퍼티
    var coordinator: Coordinator
    var viewModel: PeopleSelectionPanVM
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    init(coordinator: Coordinator,
         viewModel: PeopleSelectionPanVM) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator.didFinish()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 화면 설정

extension PeopleSelectionPanVC {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.deep_Blue
        
        [self.topLbl,
         self.bottomBtn,
         self.peopleSelectionTableView].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        
        
        // MARK: - Fix
        self.topLbl.text = "계산할 사람을 선택해 주세요."
        self.bottomBtn.setTitle("선택 완료", for: .normal)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.view.addSubview(self.stackView)
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        self.topLbl.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.bottomBtn.addTarget(
            self, 
            action: #selector(self.bottomBtnTapped),
            for: .touchUpInside)
    }
    // MARK: - 클로저 설정
    private func configureClosure() {
    }
    
    
    
    
    @objc private func bottomBtnTapped() {
        print(#function)
    }
}









// MARK: - 텍스트필드 델리게이트
extension PeopleSelectionPanVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectedUser(index: indexPath.row)
        
        // 해당 셀의 뷰를 업데이트
        guard let cell = tableView.cellForRow(at: indexPath) as? PeopleSelectionPanCell else { return }
        cell.cellIsSelected.toggle()
    }
}

// MARK: - 텍스트필드 데이터소스
extension PeopleSelectionPanVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        return self.viewModel.numOfUsers
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.peopleSelectionPanCell,
            for: indexPath) as! PeopleSelectionPanCell
        
        let user = self.viewModel.users[indexPath.row]
        cell.configureCellData(user: user)
        return cell
    }
}










// MARK: - 팬모달 설정
extension PeopleSelectionPanVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        
        return .contentHeight(self.stackView.frame.height + 10 + 15)
    }
    /// 화면 밖 - 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    /// 상단 인디케이터 없애기
    var showDragIndicator: Bool {
        return false
    }
    var cornerRadius: CGFloat {
        return 23
    }
}


// MARK: - Fix
// 테이블뷰가 0일 때 -> 아래로 스크롤하면 dismiss
