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
    
    
    private var bottomBtn: UIButton = {
        let btn = UIButton.btnWithTitle(
            titleColor: UIColor.gray,
            font: UIFont.boldSystemFont(ofSize: 16),
            backgroundColor: UIColor.unselected_Background)
        btn.isEnabled = false
        return btn
    }()
    
    
    
    
    
    private lazy var stackView: UIStackView = UIStackView.configureStv(
        arrangedSubviews: [self.topLbl,
                           self.peopleSelectionTableView,
                           self.bottomBtn],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    // MARK: - 프로퍼티
    private var coordinator: Coordinator
    private var viewModel: PeopleSelectionPanVMProtocol
    // PeopleSelection_Coordinator로 전달 됨.
    weak var delegate: PeopleSelectionDelegate?
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureViewWithViewModel()
        self.configureClosure()
    }
    init(viewModel: PeopleSelectionPanVMProtocol,
         coordinator: Coordinator) {
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
    
    // MARK: - 뷰모델을 통한 설정
    private func configureViewWithViewModel() {
        self.topLbl.text = self.viewModel.topLblText
        self.bottomBtn.setTitle(self.viewModel.bottomBtnText, for: .normal)
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
        self.viewModel.bottomBtnClosure = { [weak self] in
            // self 옵셔널 바인딩
            guard let self = self else { return }
            // 버튼 isEnable 설정
            self.bottomBtn.isEnabled = self.viewModel.bottomBtnIsEnabled
            // 버튼 색상 설정
            self.bottomBtn.backgroundColor = self.viewModel.bottomBtnColor
            // 버튼 글자 색상 설정
            self.bottomBtn.setTitleColor(
                self.viewModel.bottomBtnTextColor,
                for: .normal)
        }
    }
}










// MARK: - 바텀 버튼 액션
extension PeopleSelectionPanVC {
    @objc private func bottomBtnTapped() {
        self.dismiss(animated: true)
        // People_Selecteion_Pan_Coordinator로 전달
        self.viewModel.isSingleMode
        ? self.singleModeDelegate()
        : self.multipleModeDelegate()
    }
    
    // MARK: - 단일 선택 모드 일 때
    private func singleModeDelegate() {
        self.delegate?.payerSelectedUser(
            addedUser: self.viewModel.addedUsers)
    }
    // MARK: - 다중 선택 모드 일 때
    private func multipleModeDelegate() {
        self.delegate?.multipleModeSelectedUsers(
            addedusers: self.viewModel.addedUsers,
            removedUsers: self.viewModel.removedSelectedUsers)
    }
}










// MARK: - 테이블뷰 델리게이트

extension PeopleSelectionPanVC: UITableViewDelegate {
    
    // MARK: - 셀의 높이
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 45
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // 현재 모드 확인
        _ = self.viewModel.isSingleMode
        // 싱글 선택 모드라면
        ? self.singleModeDidSelectRowAt(
            index: indexPath.row)
        // 다중 선택 모두라면
        : self.multipleModeDidSelectRowAt(
            indexPath: indexPath)
    }
    
    // MARK: - 단일 선택 모드일 때
    private func singleModeDidSelectRowAt(index: Int) {
        self.viewModel.singleModeSelectionUser(
            index: index)
        
        guard let indexPath = self.viewModel.getSelectedUsersIndexPath()
        else { return }
        
        if let cell = self.peopleSelectionTableView.cellForRow(at: indexPath) as? PeopleSelectionPanCell {
            
            // 셀의 레이블에 새로운 텍스트를 설정합니다.
            if self.viewModel
                .isFirst {
                cell.cellStv.isTappedView.isHidden = true
                self.viewModel.isFirst.toggle()
            }
        }
    }
    
    
    
    
    
    
    // MARK: - 다중 선택 모드일 때
    private func multipleModeDidSelectRowAt(indexPath: IndexPath) {
        // 선택된 유저 저장 또는 삭제
        self.viewModel.multipleModeSelectedUsers(index: indexPath.row)
        
        // 해당 셀의 뷰를 업데이트
        guard let cell = self.peopleSelectionTableView.cellForRow(at: indexPath) as? PeopleSelectionPanCell else { return }
        cell.cellIsSelected.toggle()
    }
}





// MARK: - 테이블뷰 데이터소스

extension PeopleSelectionPanVC: UITableViewDataSource {
    
    // MARK: - 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
    -> Int {
        return self.viewModel.numOfUsers
    }
    
    // MARK: - 셀 구성
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.peopleSelectionPanCell,
            for: indexPath) as! PeopleSelectionPanCell
        // 뷰모델에서 userID와 해당 RoomUsers 객체를 가져옴
        let userEntry = self.viewModel.returnUserData(
            index: indexPath.row)
        // 셀이 선택된 상태인지 확인
        let isSelected = self.viewModel.getIdToRoomUser(
            usersID: userEntry.key)
        
        // 현재 모드 전달
        let mode = self.viewModel.isSingleMode
        
        
        // 셀에 userID와 user 데이터 설정
        cell.configureCellData(isSingleMode: mode, 
                               isSelected: isSelected,
                               userID: userEntry.key,
                               user: userEntry.value)
        
        
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
