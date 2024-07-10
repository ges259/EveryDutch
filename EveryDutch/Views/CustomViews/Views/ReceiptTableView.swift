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
    /// 영수증 테이블뷰 리로드
    func updateReceiptsTableView() {
        guard self.isViewVisible else { return }
        
        if let _ = self.viewModel.isNotificationError {
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

    private func updateIndexPath(receiptSections: [(key: String, indexPaths: [IndexPath])]) {
        print("____________________")
        print(#function)
        dump(receiptSections)
        print("____________________")
        // 행 추가, 업데이트 및 삭제를 나중에 처리
        receiptSections.forEach { (key: String, indexPaths: [IndexPath]) in
            switch key {
            case DataChangeType.added.notificationName:
                print("added")
                self.addTableViewRows(indexPaths)
            case DataChangeType.updated.notificationName:
                print("updated")
                self.updateTableViewRow(indexPaths)
            case DataChangeType.removed.notificationName:
                print("removed")
                self.removeTableViewCells(indexPaths)
            case DataChangeType.sectionInsert.notificationName:
                print("sectionInsert")
                self.insertTableViewSections(indexPaths)
            case DataChangeType.sectionRemoved.notificationName:
                print("sectionRemoved")
                self.removeTableViewSections(indexPaths)
            default:
                break
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 섹션 추가
    private func insertTableViewSections(_ indexPaths: [IndexPath]) {
        print("\(#function) ----- 1")
        // 추가하려는 섹션을 가져옴
        let sections: [Int] = self.viewModel.indexPathsToArraySet(indexPaths)
        // viewModel에서 유효성 검사 (섹션의 수를 비교)
        guard self.viewModel.validateSectionCountChange(
            currentSectionCount: self.numberOfSections,
            changedSectionsCount: sections.count
        ) else {
            print("\(#function) ----- -1")
            return
        }
        print("\(#function) ----- 2")
        print("_________ 현재 섹션의 수 _________")
        print(self.numberOfSections)
        print("_________업데이트하려는 indexPaths_________")
        dump(indexPaths)
        let indexSet = self.viewModel.createIndexSet(from: indexPaths)
        print("_________업데이트하려는 indexSet_________")
        dump(indexSet)
        print("____________________________________")
        self.insertSections(indexSet, with: .automatic)
        
//        self.addTableViewRows(indexPaths)
    }

    // 섹션 삭제
    private func removeTableViewSections(_ indexPaths: [IndexPath]) {
        print("\(#function) ----- 1")
        // 추가하려는 섹션을 가져옴
        let sections: [Int] = self.viewModel.indexPathsToArraySet(indexPaths)
        // viewModel에서 유효성 검사 (섹션의 수를 비교)
        guard self.viewModel.validateSectionCountChange(
            currentSectionCount: self.numberOfSections,
            changedSectionsCount: sections.count
        ) else {
            print("\(#function) ----- -1")
            return
        }
        print("\(#function) ----- 2")
        let indexSet = self.viewModel.createIndexSet(from: indexPaths)
        self.deleteSections(indexSet, with: .automatic)
    }
    
    private func sectionsTuple(
        _ indexPaths: [IndexPath]
    ) -> [(sectionIndex: Int,
           currentRowCount: Int,
           changedUsersCount: Int)] {
        print("\(#function) ----- 1")
        var sectionsTuple: [(sectionIndex: Int,
                             currentRowCount: Int,
                             changedUsersCount: Int)] = []

        // 추가하려는 섹션을 가져옴(배열인 상태)
        let sections = indexPaths.map { $0.section }
        let sectionsSet = Set(sections)

        // 해당 섹션의 행이 몇 개인지 가져와서, 튜플로 만듦
        for section in sectionsSet {
            // 섹션이 유효한지 확인
            guard section < self.numberOfSections else {
                print("\(#function) ----- -1")
                // 유효하지 않은 섹션인 경우 continue
                continue
            }
            print("\(#function) ----- 2")
            // 현재 해당 섹션의 행의 개수를 가져옴
            let numOfRows = self.numberOfRows(inSection: section)
            // 추가하려는 IndexPath배열에서 해당 섹션에 추가하려는 행의 개수를 가져옴
            let numOfAddedRows = indexPaths.filter { $0.section == section }.count

            // sectionsTuple에 추가
            sectionsTuple.append((sectionIndex: section,
                                  currentRowCount: numOfRows,
                                  changedUsersCount: numOfAddedRows))
        }
        dump(sectionsTuple)
        return sectionsTuple
    }
    
    // 행 추가
    private func addTableViewRows(_ indexPaths: [IndexPath]) {
        print("\(#function) ----- 1")
        // sectionsTuple을 가져옴
        let sectionsTuple = self.sectionsTuple(indexPaths)
        
        // viewModel에서 유효성 검사 (각 섹션의 행이 맞는지 확인)
        guard self.viewModel.validateRowCountChange(sectionTuple: sectionsTuple) else {
            print("\(#function) ----- -1")
            self.receiptReloadTableView()
            return
        }
        print("\(#function) ----- 2")
        self.insertRows(at: indexPaths, with: .automatic)
    }

    // 행 삭제
    private func removeTableViewCells(_ indexPaths: [IndexPath]) {
        print("\(#function) ----- 1")
        // sectionsTuple을 가져옴
        let sectionsTuple = self.sectionsTuple(indexPaths)
        
        // viewModel에서 유효성 검사 (각 섹션의 행이 맞는지 확인)
        guard self.viewModel.validateRowCountChange(sectionTuple: sectionsTuple) else {
            print("\(#function) ----- -1")
            return
        }
        print("\(#function) ----- 2")
        self.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // 행 리로드(업데이트)
    private func updateTableViewRow(_ indexPaths: [IndexPath]) {
        print("\(#function) ----- 1")
        // viewModel에서 유효성 검사 (각 섹션의 행이 맞는지 확인)
        guard self.viewModel.validateRowExistenceForUpdate(indexPaths: indexPaths) else {
            print("\(#function) ----- -1")
            self.updateTableSections(indexPaths)
            return
        }
        print("\(#function) ----- 2")
        self.reloadRows(at: indexPaths, with: .automatic)
    }
    // 섹션 리로드
    private func updateTableSections(_ indexPaths: [IndexPath]) {
        print("\(#function) ----- 1")
        // 추가하려는 섹션을 가져옴
        guard self.viewModel.validateSectionsExistenceForUpdate(indexPaths: indexPaths) else {
            print("\(#function) ----- -1")
            return
        }
        print("\(#function) ----- 2")
        // 추가하려는 IndeSet을 가져옴
        let indexSet = self.viewModel.createIndexSet(from: indexPaths)
        // 해당 섹션의 행이 몇 개인지 가져와서, 튜플로 만듦
        self.reloadSections(indexSet, with: .automatic)
    }
    
    
    

    
    
    
    private func receiptReloadTableView() {
        print("DEBUG: \(self)----- \(#function)")
        self.reloadData()
    }
}
