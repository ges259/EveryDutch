//
//  ReceiptTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 6/26/24.
//

import UIKit
import SnapKit

final class ReceiptTableView: UITableView {
    
    // MARK: - 프로퍼티
    private let viewModel: ReceiptTableViewViewModelProtocol
    weak var receiptDelegate: ReceiptTableViewDelegate?
    private lazy var cellHeight: CGFloat = self.frame.width / 7 * 2
    
    var isViewVisible: Bool = true {
        didSet { self.updateReceiptsTableView() }
    }
    
    
    
    // MARK: - 라이프사이클
    init(viewModel: ReceiptTableViewViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .grouped)
        
        self.configureUI()
        self.configureTableView()
        self.configureNotification()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit { NotificationCenter.default.removeObserver(self) }
    
    
    
    // MARK: - 테이블뷰 크기 설정
    override var contentSize: CGSize {
        didSet { self.invalidateIntrinsicContentSize() }
    }
    /*
     - intrinsic_Content_Size
     - 자신의 컨텐츠 사이즈에 따라서 결정되는 뷰 사이즈
     - ex) 레이블 (width와 height를 설정해주지 않아도 글자의 크기에 맞춰 크기가 결정 됨)
     - view의 컨텐츠 크기가 바뀌었을 때 instrinsicContentSize 프로퍼티를 통해 size를 갱신하고 그에 맞게 auto_Layout을 업데이트되도록 만들어주는 메서드
     결론 -> 내부 사이즈가 변할 때마다 intrinsicContentSize 프로퍼티가 호출 됨
     */
    override var intrinsicContentSize: CGSize {
        //        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: self.contentSize.height)
    }
}










// MARK: - 화면 설정
extension ReceiptTableView {
    private func configureTableView() {
        self.register(
            SettlementTableViewCell.self,
            forCellReuseIdentifier: Identifier.settlementTableViewCell)
        self.register(
            ReceiptSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: Identifier.receiptSectionHeaderView)
        
        self.delegate = self
        self.dataSource = self
        
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
//        self.bounces = true
        self.bounces = false
        self.transform = CGAffineTransform(rotationAngle: .pi)
        self.sectionHeaderTopPadding = 0
    }
    
    private func configureUI() {
//        self.backgroundColor = .clear
        self.backgroundColor = .red
        self.setRoundedCorners(.all, withCornerRadius: 10)
    }
    func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleDataChanged(notification:)),
            name: Notification.Name.receiptDataChanged,
            object: nil)
    }
}










// MARK: - viewWillAppear 업데이트
extension ReceiptTableView {
    /// 노티피케이션을 통해 받은 변경사항을 바로 반영하거나 저장하는 메서드
    @objc private func handleDataChanged(notification: Notification) {
        
        guard let dataInfo = notification.userInfo as? [String: Any] else { return }
        
        let rawValue = notification.name.rawValue
        
        switch rawValue {
        case Notification.Name.receiptDataChanged.rawValue:
            self.viewModel.receiptDataChanged(dataInfo)
        default:
            break
        }
        self.updateReceiptsTableView()
    }
    
    /// 영수증 테이블뷰 리로드
    func updateReceiptsTableView() {
        guard self.isViewVisible else { return }
        
        if let _ = self.viewModel.isNotificationError {
            self.viewModel.hasNoMoreDataSetTrue()
        }
        
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
            self.reloadData()
        }
        
        self.viewModel.resetPendingReceiptIndexPaths()
    }
    
    private func reloadTableViewSections(_ sections: [Int]) {
        let sectionsToReload = IndexSet(sections)
        print(#function)
        self.beginUpdates()
        self.reloadSections(sectionsToReload, with: .none)
        self.endUpdates()
        
        print("Sections to reload: \(sectionsToReload)")
    }
    
    private func insertTableViewSections(_ sections: [Int]) {
        let sectionsToInsert = IndexSet(sections)
        print(#function)
        self.beginUpdates()
        self.insertSections(sectionsToInsert, with: .none)
        self.endUpdates()
        
        print("Sections to insert: \(sectionsToInsert)")
    }
    
    private func updateReceiptTableViewCell(_ sections: [Int]) {
        print(#function)
        let sectionsToReload = IndexSet(sections)
        
        self.beginUpdates()
        self.reloadSections(sectionsToReload, with: .none)
        self.endUpdates()
        
        print("Sections to update: \(sectionsToReload)")
    }
    
    private func removeTableViewCells() {
        let indexPathsDict = self.viewModel.getPendingReceiptIndexPaths()
        
        // 키가 DataChangeType.removed.notificationName인 인덱스 경로만 필터링
        if let removedIndexPaths = indexPathsDict[DataChangeType.removed.notificationName], !removedIndexPaths.isEmpty {
            print(#function)
            self.beginUpdates()
            self.deleteRows(at: removedIndexPaths, with: .none)
            self.endUpdates()
            
            print("Cells to remove: \(removedIndexPaths)")
        }
    }
    
    
    private func removeTableViewSections(_ sections: [Int]) {
        let sectionsToRemove = IndexSet(sections)
        print(#function)
        self.beginUpdates()
        self.deleteSections(sectionsToRemove, with: .none)
        self.endUpdates()
        
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
                   didSelectRowAt indexPath: IndexPath
    ) {
        // MARK: - Fix
        // 뷰모델에서 셀의 영수증 가져오기
        let receipt = self.viewModel.getReceipt(at: indexPath)
        // '영수증 화면'으로 화면 이동
        self.receiptDelegate?.didSelectRowAt(receipt)
    }
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        guard !self.viewModel.hasNoMoreData,
                indexPath.section == self.viewModel.numOfSections - 1 
        else { return }
        // 마지막 셀
        self.receiptDelegate?.willDisplayLastCell()
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
                   numberOfRowsInSection section: Int
    ) -> Int {
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
        let cell = self.dequeueReusableCell(
            withIdentifier: Identifier.settlementTableViewCell,
            for: indexPath) as! SettlementTableViewCell
        
        // 셀 뷰모델 만들기
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath)
        let isFistCell = indexPath.row == 0
        let isLastCell = self.viewModel.isLastCell(indexPath: indexPath)
        
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(
            with: cellViewModel,
            isFirst: isFistCell,
            isLast: isLastCell)
        
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
    func hasNoMoreDataSetTrue()
    var hasNoMoreData: Bool { get }
    
    
    
    
    // 영수증 테이블뷰 (delgate / dataSource)
    var numOfSections: Int { get }
    func numOfReceipts(section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol
    func getReceipt(at indexPath: IndexPath) -> Receipt
    func getReceiptSectionDate(section: Int) -> String
    
    func isLastCell(indexPath: IndexPath) -> Bool
    
    // 노티피케이션
    var isNotificationError: ErrorEnum? { get }
    func receiptDataChanged(_ userInfo: [String: Any])
    func getPendingReceiptIndexPaths() -> [String: [IndexPath]]
    func getPendingReceiptSections() -> [String: [Int]]
    func resetPendingReceiptIndexPaths()
}

final class ReceiptTableViewViewModel: ReceiptTableViewViewModelProtocol {
    
    private let roomDataManager: RoomDataManagerProtocol
    
    // 플래그
    private let _isSearchMode: Bool
    private var _hasNoMoreData: Bool = false
    
    
    // MARK: - 라이프사이클
    init (roomDataManager: RoomDataManagerProtocol,
          isSearchMode: Bool) {
        self.roomDataManager = roomDataManager
        self._isSearchMode = isSearchMode
    }
    
    
    // MARK: - 플래그 변경
    func hasNoMoreDataSetTrue() {
        self._hasNoMoreData = true
    }
    
    // MARK: - 데이터 리턴
    var isSearchMode: Bool {
        return self._isSearchMode
    }
    var hasNoMoreData: Bool {
        return self._hasNoMoreData
    }
    
    
    
    // MARK: - 테이블뷰
    /// 섹션의 타이틀(날짜)를 반환
    func getReceiptSectionDate(section: Int) -> String {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceiptSectionDate(section: section)
        : self.roomDataManager.getRoomReceiptSectionDate(section: section)
    }
    /// 섹션의 개수
    var numOfSections: Int {
        return self._isSearchMode
        ? self.roomDataManager.getNumOfUserReceiptsSection
        : self.roomDataManager.getNumOfRoomReceiptsSection
    }
    /// 영수증 개수
    func numOfReceipts(section: Int) -> Int {
        return self._isSearchMode
        ? self.roomDataManager.getNumOfUserReceipts(section: section)
        : self.roomDataManager.getNumOfRoomReceipts(section: section)
    }
    /// 영수증 셀의 뷰모델 반환
    func cellViewModel(at indexPath: IndexPath) -> ReceiptTableViewCellVMProtocol {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceiptViewModel(indexPath: indexPath)
        : self.roomDataManager.getRoomReceiptViewModel(indexPath: indexPath)
    }
    /// 셀 선택 시, 해당 셀의 영수증 반환
    func getReceipt(at indexPath: IndexPath) -> Receipt {
        return self._isSearchMode
        ? self.roomDataManager.getUserReceipt(at: indexPath)
        : self.roomDataManager.getRoomReceipt(at: indexPath)
    }
    func isLastCell(indexPath: IndexPath) -> Bool {
        return self._isSearchMode
        ? indexPath.row == self.roomDataManager.getNumOfUserReceipts(section: indexPath.section) - 1
        : indexPath.row == self.roomDataManager.getNumOfRoomReceipts(section: indexPath.section) - 1
    }
    
    
    
    
    
    // MARK: - 인덱스패스
    private var _receiptDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    private var _receiptSearchModeDataManager: IndexPathDataManager<Receipt> = IndexPathDataManager()
    
    var isNotificationError: ErrorEnum? {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.error
        : self._receiptDataManager.error
    }
    
    // 영수증 데이터 인덱스패스
    func receiptDataChanged(_ userInfo: [String: Any]) {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.dataChanged(userInfo)
        : self._receiptDataManager.dataChanged(userInfo)
    }
    
    func getPendingReceiptIndexPaths() -> [String: [IndexPath]] {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.getPendingIndexPaths()
        : self._receiptDataManager.getPendingIndexPaths()
    }
    func getPendingReceiptSections() -> [String: [Int]] {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.getPendingSections()
        : self._receiptDataManager.getPendingSections()
    }

    func resetPendingReceiptIndexPaths() {
        return self._isSearchMode
        ? self._receiptSearchModeDataManager.resetIndexPaths()
        : self._receiptDataManager.resetIndexPaths()
    }
}
