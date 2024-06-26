//
//  ReceiptTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 6/26/24.
//

import UIKit
import SnapKit

final class ReceiptTableView: UITableView {
    
    // MARK: - 레이아웃
    /// 정산내역 테이블뷰
    private lazy var receiptTableView: CustomTableView = {
        let view = CustomTableView(frame: .zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        view.register(
            ReceiptSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: Identifier.receiptSectionHeaderView)
        view.backgroundColor = .clear
        view.bounces = true
        view.transform = CGAffineTransform(rotationAngle: .pi)
        view.sectionHeaderTopPadding = 0
        // 영수증 테이블뷰 모서리 설정
        view.setRoundedCorners(.all, withCornerRadius: 10)
        return view
    }()
    
    
    
    
    
    // MARK: - 프로퍼티
    private let viewModel: ReceiptTableViewViewModelProtocol
    weak var receiptDelegate: ReceiptTableViewDelegate?
    private lazy var cellHeight: CGFloat = self.frame.width / 7 * 2

    
    
    
    
    // MARK: - 라이프사이클
    init(viewModel: ReceiptTableViewViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .grouped)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureNotification()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 화면 설정
    private func configureUI() {
        
    }
    
    private func configureAutoLayout() {
        self.addSubview(self.receiptTableView)
        // 영수증 테이블뷰 (영수증)
        self.receiptTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func configureNotification() {
        
        let notificationName = self.viewModel.isSearchMode
        ? Notification.Name.receiptSearchModeChanged
        : Notification.Name.receiptDataChanged
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleDataChanged(notification:)),
            name: notificationName,
            object: nil)
    }
}










// MARK: - viewWillAppear 업데이트
extension ReceiptTableView {
    /// 노티피케이션을 통해 받은 변경사항을 바로 반영하거나 저장하는 메서드
    @objc private func handleDataChanged(notification: Notification) {
        guard let dataInfo = notification.userInfo as? [String: [IndexPath]] else { return }
        let rawValue = notification.name.rawValue
        
        switch rawValue {
        case Notification.Name.receiptSearchModeChanged.rawValue:
            self.viewModel.receiptSearchModeDataChanged(dataInfo)
            
        case Notification.Name.receiptDataChanged.rawValue:
            self.viewModel.receiptDataChanged(dataInfo)
            
        default:
            break
        }
    }
    
    /// 영수증 테이블뷰 리로드
    private func updateReceiptsTableView() {
        let receiptSections = self.viewModel.getPendingReceiptSections()
        
        if receiptSections.keys.count == 1 {
            receiptSections.forEach { (key: String, sections: [Int]) in
                switch key {
                case DataChangeType.sectionInsert.notificationName:
                    self.insertTableViewSections(sections)
                    
                case DataChangeType.sectionReload.notificationName:
                    self.reloadTableViewSections(sections)
                    
                case DataChangeType.updated.notificationName:
                    self.updateReceiptTableViewCell(sections)
                    
                case DataChangeType.removed.notificationName:
                    self.removeTableViewCells()
                    
                case DataChangeType.sectionRemoved.notificationName:
                    self.removeTableViewSections(sections)
                    
                default:
                    break
                }
            }
        } else {
            self.receiptTableView.reloadData()
        }
        
        self.viewModel.resetPendingReceiptIndexPaths()
    }
    
    private func reloadTableViewSections(_ sections: [Int]) {
        let sectionsToReload = IndexSet(sections)
        print(#function)
        self.receiptTableView.beginUpdates()
        self.receiptTableView.reloadSections(sectionsToReload, with: .none)
        self.receiptTableView.endUpdates()
        
        print("Sections to reload: \(sectionsToReload)")
    }
    
    private func insertTableViewSections(_ sections: [Int]) {
        let sectionsToInsert = IndexSet(sections)
        print(#function)
        self.receiptTableView.beginUpdates()
        self.receiptTableView.insertSections(sectionsToInsert, with: .none)
        self.receiptTableView.endUpdates()
        
        print("Sections to insert: \(sectionsToInsert)")
    }
    
    private func updateReceiptTableViewCell(_ sections: [Int]) {
        print(#function)
        let sectionsToReload = IndexSet(sections)
        
        self.receiptTableView.beginUpdates()
        self.receiptTableView.reloadSections(sectionsToReload, with: .none)
        self.receiptTableView.endUpdates()
        
        print("Sections to update: \(sectionsToReload)")
    }
    
    private func removeTableViewCells() {
        let indexPathsDict = self.viewModel.getPendingReceiptIndexPaths()
        
        // 키가 DataChangeType.removed.notificationName인 인덱스 경로만 필터링
        if let removedIndexPaths = indexPathsDict[DataChangeType.removed.notificationName], !removedIndexPaths.isEmpty {
            print(#function)
            self.receiptTableView.beginUpdates()
            self.receiptTableView.deleteRows(at: removedIndexPaths, with: .none)
            self.receiptTableView.endUpdates()
            
            print("Cells to remove: \(removedIndexPaths)")
        }
    }
    
    
    private func removeTableViewSections(_ sections: [Int]) {
        let sectionsToRemove = IndexSet(sections)
        print(#function)
        self.receiptTableView.beginUpdates()
        self.receiptTableView.deleteSections(sectionsToRemove, with: .none)
        self.receiptTableView.endUpdates()
        
        print("Sections to remove: \(sectionsToRemove)")
    }
}










// MARK: - 테이블뷰 델리게이트
extension ReceiptTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        // MARK: - Fix
        // 뷰모델에서 셀의 영수증 가져오기
        let receipt = self.viewModel.getReceipt(at: indexPath)
        // '영수증 화면'으로 화면 이동
        self.receiptDelegate?.didSelectRowAt(receipt)
    }
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        // MARK: - Fix
//        // 마지막 셀
//        if indexPath.section == self.viewModel.numOfSections - 1 {
//            self.viewModel.loadMoreReceiptData()
//        }
//        self.receiptDelegate?.willDisplayLastCell()
        
    }
}

// MARK: - 테이블뷰 데이터 소스
extension ReceiptTableView: UITableViewDataSource {
    /// 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numOfSections
    }
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numOfReceipts(section: section)
    }
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int
    ) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Identifier.receiptSectionHeaderView) as? ReceiptSectionHeaderView else {
            return nil
        }
        let sectionInfo = self.viewModel.getReceiptSectionDate(section: section)
        
        headerView.configure(with: sectionInfo,
                             labelBackgroundColor: .deep_Blue)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40 // 최소 높이를 40으로 설정
    }
    
    /// 헤더를 nil로 설정
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int
    ) -> UIView? {
        return nil
    }
    /// 헤더의 높이를 0으로 설정
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 0
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = self.receiptTableView.dequeueReusableCell(
            withIdentifier: Identifier.settlementTableViewCell,
            for: indexPath) as! SettlementTableViewCell
        
        // 셀 뷰모델 만들기
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath)
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(with: cellViewModel)
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        cell.backgroundColor = .normal_white
        return cell
    }
}




















protocol ReceiptTableViewDelegate: AnyObject {
    func didSelectRowAt(_ receipt: Receipt)
    func willDisplayLastCell()
}

protocol ReceiptTableViewViewModelProtocol {
    
    var isSearchMode: Bool { get }
    
    // 영수증 테이블뷰 (delgate / dataSource)
    var numOfSections: Int { get }
    func numOfReceipts(section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol
    func getReceipt(at indexPath: IndexPath) -> Receipt
    func getReceiptSectionDate(section: Int) -> String
    
    
    // 노티피케이션
    func receiptDataChanged(_ userInfo: [String: [IndexPath]])
    func receiptSearchModeDataChanged(_ userInfo: [String: [IndexPath]])
    func getPendingReceiptIndexPaths() -> [String: [IndexPath]]
    func getPendingReceiptSections() -> [String: [Int]]
    func resetPendingReceiptIndexPaths()
}

final class ReceiptTableViewViewModel: ReceiptTableViewViewModelProtocol {
    
    private let roomDataManager: RoomDataManagerProtocol
    private let _isSearchMode: Bool
    
    init (roomDataManager: RoomDataManagerProtocol,
          isSearchMode: Bool) {
        self.roomDataManager = roomDataManager
        self._isSearchMode = isSearchMode
    }
    
    var isSearchMode: Bool {
        return self._isSearchMode
    }
    
    
    
    
    
    /// 섹션의 타이틀(날짜)를 반환
    func getReceiptSectionDate(section: Int) -> String {
        return self.roomDataManager.getReceiptSectionDate(section: section)
    }
    /// 섹션의 개수
    var numOfSections: Int {
        return self.roomDataManager.getNumOfRoomReceiptsSection
    }
    /// 영수증 개수
    func numOfReceipts(section: Int) -> Int {
        return self.roomDataManager.getNumOfRoomReceipts(section: section)
    }
    /// 영수증 셀의 뷰모델 반환
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol {
        return self.roomDataManager.getReceiptViewModel(indexPath: indexPath)
    }
    /// 셀 선택 시, 해당 셀의 영수증 반환
    func getReceipt(at indexPath: IndexPath) -> Receipt {
        return self.roomDataManager.getRoomReceipt(at: indexPath)
    }
    
    
    
    
    
    
    
    
    
    
    
    private var _receiptDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    private var _receiptSearchModeDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    
    
    // 영수증 데이터 인덱스패스
    func receiptDataChanged(_ userInfo: [String: [IndexPath]]) {
        self._receiptDataManager.dataChanged(userInfo)
    }
    
    func receiptSearchModeDataChanged(_ userInfo: [String: [IndexPath]]) {
        self._receiptDataManager.dataChanged(userInfo)
    }
    
    
    
    
    func getPendingReceiptIndexPaths() -> [String: [IndexPath]] {
        return self._receiptDataManager.getPendingIndexPaths()
    }
    func getPendingReceiptSections() -> [String: [Int]] {
        return self._receiptDataManager.getPendingSections()
    }

    func resetPendingReceiptIndexPaths() {
        self._receiptDataManager.resetIndexPaths()
    }
}
