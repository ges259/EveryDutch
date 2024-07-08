//
//  ReceiptTableView.swift
//  EveryDutch
//
//  Created by 계은성 on 6/26/24.
//

import UIKit
import SnapKit

protocol ReceiptTableViewDelegate: AnyObject {
    func didSelectRowAt(_ receipt: Receipt)
    func willDisplayLastCell()
}

final class ReceiptTableView: CustomTableView {
    
    // MARK: - 프로퍼티
    private let viewModel: ReceiptTableViewVMProtocol
    weak var receiptDelegate: ReceiptTableViewDelegate?
    
    var isViewVisible: Bool = true {
        didSet { self.updateReceiptsTableView() }
    }
    
    
    
    // MARK: - 라이프사이클
    init(viewModel: ReceiptTableViewVMProtocol) {
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
}










// MARK: - 화면 설정
extension ReceiptTableView {
    private func configureTableView() {
        self.register(
            ReceiptTableViewCell.self,
            forCellReuseIdentifier: Identifier.receiptTableViewCell)
        self.register(
            ReceiptSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: Identifier.receiptSectionHeaderView)
        
        self.delegate = self
        self.dataSource = self
        
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.bounces = true
        self.transform = CGAffineTransform(rotationAngle: .pi)
        self.sectionHeaderTopPadding = 0
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
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










// MARK: - 테이블뷰 업데이트
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
    /*
     1. insertSections와 removeSections
     2. insertRows와 removeRows
     3. insertRows또는 removeRows 와 reloadRows
     */
    /// 영수증 테이블뷰 리로드
    func updateReceiptsTableView() {
        guard self.isViewVisible else { return }
        
        if let _ = self.viewModel.isNotificationError {
            self.viewModel.hasNoMoreDataSetTrue()
        }
        
        let receiptSections = self.viewModel.getPendingReceiptSections()
        
        guard receiptSections.count != 0 else { return }
        
        DispatchQueue.main.async {
            if receiptSections.count == 1 {
                self.updateIndexPath(receiptSections: receiptSections)
            } else {
                self.reloadData()
            }
        }
        // 변경된 IndexPath배열을 리셋
        self.viewModel.resetPendingReceiptIndexPaths()
    }
    
    private func updateIndexPath(receiptSections: [String : [Int]]) {
        receiptSections.forEach { (key: String, sections: [Int]) in
            switch key {
                // 섹션 추가
            case DataChangeType.sectionInsert.notificationName:
                self.insertTableViewSections(sections)
                // 행 추가
            case DataChangeType.added.notificationName:
                self.addTableViewRows(sections)
                // 행 업데이트
            case DataChangeType.updated.notificationName:
                self.updateTableViewRow(sections)
                // 행 제거
            case DataChangeType.removed.notificationName:
                self.removeTableViewCells(sections)
                // 섹션 제거
            case DataChangeType.sectionRemoved.notificationName:
                self.removeTableViewSections(sections)
                
            default:
                break
            }
        }
    }

    // 섹션 추가
    private func insertTableViewSections(_ sections: [Int]) {
        let sectionsToInsert = IndexSet(sections)
        print(#function)
        self.beginUpdates()
        self.insertSections(sectionsToInsert, with: .none)
        self.endUpdates()
        
        print("Sections to insert: \(sectionsToInsert)")
    }
    // 섹션 삭제
    private func removeTableViewSections(_ sections: [Int]) {
        let sectionsToRemove = IndexSet(sections)
        print(#function)
        self.beginUpdates()
        self.deleteSections(sectionsToRemove, with: .none)
        self.endUpdates()
        
        print("Sections to remove: \(sectionsToRemove)")
    }
    
    // 행 추가
    private func addTableViewRows(_ sections: [Int]) {
    }
    
    // 행 리로드(업데이트)
    private func updateTableViewRow(_ sections: [Int]) {
    }
    
    // 행 삭제
    private func removeTableViewCells(_ sections: [Int]) {
        let indexPathsDict = self.viewModel.getPendingReceiptIndexPaths()
        
        // 키가 DataChangeType.removed.notificationName인 인덱스 경로만 필터링
        guard let removedIndexPaths = indexPathsDict[DataChangeType.removed.notificationName],
              !removedIndexPaths.isEmpty
        else {
            // 해당 섹션을 리로드
            return
        }
        
        print(#function)
        self.beginUpdates()
        self.deleteRows(at: removedIndexPaths, with: .none)
        self.endUpdates()
        
        print("Cells to remove: \(removedIndexPaths)")
    }
    

    
    
    private func reloadTableView() {
        print("DEBUG: \(#function)")
        self.reloadData()
    }
}










// MARK: - 테이블뷰 델리게이트
extension ReceiptTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        // 뷰모델에서 셀의 영수증 가져오기
        guard let receipt = self.viewModel.getReceipt(at: indexPath) else { return }
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
        if let numOfReceipts = self.viewModel.numOfReceipts(section: section) {
            return numOfReceipts
        } else {
            // numOfReceipts가 nil인 경우
            DispatchQueue.main.async { tableView.reloadData() }
            return 0
        }
    }
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int
    ) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Identifier.receiptSectionHeaderView) as? ReceiptSectionHeaderView else {
            return nil
        }
        let sectionInfo = self.viewModel.getReceiptSectionDate(section: section)
        
        headerView.configure(
            with: sectionInfo,
            labelBackgroundColor: self.viewModel.haederSectionBackgroundColor
        )
        return headerView
    }
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int
    ) -> CGFloat {
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
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = self.dequeueReusableCell(
            withIdentifier: Identifier.receiptTableViewCell,
            for: indexPath) as! ReceiptTableViewCell
        
        // 셀 뷰모델 만들기
        let cellViewModel = self.viewModel.cellViewModel(at: indexPath)
        let isFistCell = indexPath.row == 0
        let isLastCell = self.viewModel.isLastCell(indexPath: indexPath)
        
        // 셀의 뷰모델을 셀에 넣기
        cell.configureCell(
            with: cellViewModel,
            isFirst: isFistCell,
            isLast: isLastCell ?? false)
        
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        return cell
    }
}







/*
 // 행 추가
 private func addTableViewRows(_ sections: [Int]) {
//        let sectionsToReload = IndexSet(sections)
//        print(#function)
//        self.beginUpdates()
//        self.reloadSections(sectionsToReload, with: .none)
//        self.endUpdates()
//
//        print("Sections to reload: \(sectionsToReload)")
 }
 
 // 행 리로드(업데이트)
 private func updateTableViewRow(_ sections: [Int]) {
//        print(#function)
//        let sectionsToReload = IndexSet(sections)
//
//        self.beginUpdates()
//        self.reloadSections(sectionsToReload, with: .none)
//        self.endUpdates()
//
//        print("Sections to update: \(sectionsToReload)")
 }
 */
