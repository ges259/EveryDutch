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
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleDataChanged(notification:)),
            name: Notification.Name.searchDataChanged,
            object: nil
        )
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
        print("delegate를 통한 fetch")
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
        if let numOfReceipts = self.viewModel.numOfRows(in: section) {
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
    // 헤더뷰의 높이를 설정
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int
    ) -> CGFloat {
        return 40 // 최소 높이를 40으로 설정
    }
    
    /// 푸터를 nil로 설정
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int
    ) -> UIView? {
        return nil
    }
    /// 푸터의 높이를 0으로 설정
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










// MARK: - 테이블뷰 업데이트
extension ReceiptTableView {
    /// 노티피케이션을 통해 받은 변경사항을 바로 반영하거나 저장하는 메서드
    @objc private func handleDataChanged(notification: Notification) {
        
        guard let dataInfo = notification.userInfo as? [String: Any] else { return }
        
        let rawValue = notification.name.rawValue
        
        switch rawValue {
        case Notification.Name.receiptDataChanged.rawValue:
            self.viewModel.receiptDataChanged(dataInfo)
            
        case Notification.Name.searchDataChanged.rawValue:
            self.viewModel.searchDataChanged(dataInfo)
            
        default:
            break
        }
        self.updateReceiptsTableView()
    }
    /// 영수증 테이블뷰 리로드
    func updateReceiptsTableView() {
        guard self.isViewVisible else { return }
        
        if let _ = self.viewModel.isNotificationError {
            print("\(#function) ----- 데이터 더이상 없음")
            self.viewModel.hasNoMoreDataSetTrue()
        }
        
        let receiptSections: [(key: String, indexPaths: [IndexPath])] = self.viewModel.getPendingReceiptIndexPaths()
        
        guard !receiptSections.isEmpty else { return }
        
        DispatchQueue.main.async {
            self.updateIndexPath(receiptSections: receiptSections)
        }
        // 변경된 IndexPath배열을 리셋
        self.viewModel.resetPendingReceiptIndexPaths()
    }
    
    // 메인 업데이트 메소드
    private func updateIndexPath(
        receiptSections: [(key: String, indexPaths: [IndexPath])]
    ) {
        print("_____________________________")
        print("_____________________________")
        print("_____________________________")
        print("_____________________________")
        print("_____________________________")
        print(#function)
        dump(receiptSections)
        print("업데이트된 테이블의 섹션의 개수: \(self.numberOfSections)")
        print("_____________________________")
        print("_____________________________")
        print("_____________________________")
        print("_____________________________")
        print("_____________________________")
        
        do {
            print("100 ----- 1")
            // 섹션 [추가 및 삭제]에 대한 유효성 검사
            try self.validationInsertSections(receiptSections)
            print("100 ----- 2")
            // 행 [추가 및 삭제]에 대한 유효성 검사
            try self.validateRowChanges(receiptSections)
            print("100 ----- 3")
            // 행 [리로드]에 대한 유효성 검사
            try self.validationReloadRow(receiptSections)
            print("100 ----- 4")
            // 테이블뷰 업데이트
            try self.performBatchUpdatesWithRollback(receiptSections)
            print("100 ----- 5")
            
        } catch {
            print("DEBUG111 : reloadData")
            self.reloadData()
        }
    }
    
    // performBatchUpdates with rollback
    private func performBatchUpdatesWithRollback(
        _ receiptSections: [(key: String, indexPaths: [IndexPath])]
    ) throws {

        
        
        var didThrowError = false
        
        UIView.performWithoutAnimation {
            self.performBatchUpdates({
                receiptSections.forEach { [weak self] (key: String, indexPaths: [IndexPath]) in
                    guard let self = self else { return }
                    
                    switch key {
                    case DataChangeType.added.notificationName:
                        self.handleAdditions(indexPaths)
                        
                    case DataChangeType.sectionInsert.notificationName:
                        self.insertTableViewSections(indexPaths)
                        
                    case DataChangeType.updated.notificationName:
                        self.updateTableViewRow(indexPaths)
                        
                    case DataChangeType.sectionRemoved.notificationName:
                        self.removeTableViewSections(indexPaths)
                        
                    case DataChangeType.removed.notificationName:
                        self.removeTableViewCells(indexPaths)
                    default:
                        break
                    }
                }
            }, completion: { finished in
                if !finished {
                    didThrowError = true
                }
            })
        }
        // 1711897200 // 4/1
        // 1720018800 // 7/4
        // 1720450800 // 7/9
        // 1721280576 // 7/18

        
        if didThrowError {
            throw NSError(domain: "BatchUpdatesFailed", code: 1, userInfo: nil)
        }
    }
    
    // 섹션 추가
    private func insertTableViewSections(_ indexPaths: [IndexPath]) {
        print("11111111111111 ----- \(#function)")
        let indexSet = self.viewModel.createIndexSet(from: indexPaths)
        self.insertSections(indexSet, with: .none)
    }
    
    // 행 추가
    private func handleAdditions(_ indexPaths: [IndexPath]) {
        print("11111111111111 ----- \(#function)")
        self.insertRows(at: indexPaths, with: .none)
    }
    
    // 행 업데이트
    private func updateTableViewRow(_ indexPaths: [IndexPath]) {
        print("11111111111111 ----- \(#function)")
        self.reloadRows(at: indexPaths, with: .none)
    }
    
    // 섹션 삭제
    private func removeTableViewSections(_ indexPaths: [IndexPath]) {
        print("11111111111111 ----- \(#function)")
        let indexSet = self.viewModel.createIndexSet(from: indexPaths)
        self.deleteSections(indexSet, with: .none)
    }
    
    // 행 삭제
    private func removeTableViewCells(_ indexPaths: [IndexPath]) {
        print("11111111111111 ----- \(#function)")
        self.deleteRows(at: indexPaths, with: .none)
        
        
    }
    private func moveTableRows(_ indexPaths: [IndexPath]) {
        guard indexPaths.count >= 2 else { return }
        
        self.moveRow(at: indexPaths[0], to: indexPaths[1])
    }
}










// MARK: -  유효성 검사
extension ReceiptTableView {
    
    /// 섹션 유효성 검사
    private func validationInsertSections(
        _ receiptSections: [(key: String,
                             indexPaths: [IndexPath])]
    ) throws {
        guard self.viewModel.isValidSectionChangeCount(
            receiptSections: receiptSections,
            currentSectionCount: self.numberOfSections
        ) else {
            throw ErrorEnum.readError
        }
    }
    /// 행 유효성 검사
    private func validateRowChanges(
        _ receiptSections: [(key: String, indexPaths: [IndexPath])]
    ) throws {
        guard
            self.viewModel.isValidRowsChanged(
                receiptSections,
                numberOfRowsInSection: { [weak self] section in
                    // 약한 참조로 self를 사용하여 메모리 누수를 방지
                    guard let self = self else { return nil }
                    // 현재 섹션 인덱스가 유효한 경우 해당 섹션의 행 수를 반환
                    guard section < self.numberOfSections else { return nil }
                    // 해당 섹션의 행의 개수를 보냄
                    return self.numberOfRows(inSection: section)
                }
            ) else {
            // 유효성 검사를 실패하면 에러를 던짐
            throw ErrorEnum.readError
        }
    }
    
    
    /// 리로드 유효성 검사
    private func validationReloadRow(
        _ receiptSections: [(key: String, indexPaths: [IndexPath])]
    ) throws {
        guard
            // 영수증 섹션들에 대한 행 재로드 유효성 검사를 뷰모델에 위임
            self.viewModel.canReloadRows(
                // 튜플 배열을 보내기
                in: receiptSections,
                // 클로저: 섹션의 대한 행의 개수를 보냄
                numberOfRowsInSection: { [weak self] section in
                    // 약한 참조로 self를 사용하여 메모리 누수를 방지
                    guard let self = self else { return nil }
                    // 현재 섹션 인덱스가 유효한 경우 해당 섹션의 행 수를 반환
                    guard section < self.numberOfSections else { return nil }
                    // 해당 섹션의 행의 개수를 보냄
                    return self.numberOfRows(inSection: section)
                }
            ) else {
            // 유효성 검사를 실패하면 에러를 던짐
            throw ErrorEnum.readError
        }
    }
    
}
