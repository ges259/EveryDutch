//
//  Receipt_Enum.swift
//  EveryDutch
//
//  Created by 계은성 on 2024/01/04.
//

import UIKit


protocol ReceiptWriteCellType {
    var databaseString: String { get }
}



enum ReceiptWriteEnum: Int, CaseIterable {
    case receiptData
    case userData
    
    var headerTitle: String {
        switch self {
        case .receiptData:
            return "영수증 정보"
        case .userData:
            return "금액 입력"
        }
    }
    
    
    func validation(data: [String: Any?]) -> [String] {
        return ReceiptCellEnum.validation(dict: data)
    }
    
    func createProviders(
        isReceiptWriteVC: Bool,
        withData receipt: Receipt?) -> [Int: [ReceiptWriteCellVMProtocol]]
    {
        var detailsDictionary: [Int: [ReceiptWriteCellVMProtocol]] = [:]
        
        ReceiptWriteEnum.allCases.forEach { roomEditEnum in
            switch roomEditEnum {
            case .receiptData:
                let receiptData = ReceiptCellEnum.getDetails(
                    isReceiptWriteVC: isReceiptWriteVC, 
                    receipt: receipt)
                detailsDictionary[roomEditEnum.rawValue] = receiptData
                break
                
            case .userData:
                break
            }
        }
        return detailsDictionary
    }
    var sectionIndex: Int {
        return self.rawValue
    }
    
    func getRawValue(section: Int) -> ReceiptWriteEnum? {
        return ReceiptWriteEnum(rawValue: section)
    }
}




enum ReceiptCellEnum: Int, CaseIterable, ReceiptWriteCellType {
    
    case date = 0
    case time
    
    case memo
    case price
    case payer
    
    case payment_Method
    
    var databaseString: String {
        switch self {
        case .memo:             return DatabaseConstants.context
        case .date:             return DatabaseConstants.date
        case .time:             return DatabaseConstants.time
        case .price:            return DatabaseConstants.price
        case .payer:            return DatabaseConstants.payer
        case .payment_Method:   return DatabaseConstants.payment_method
        }
    }
    
    
    
    // 각 케이스에 대한 이미지와 텍스트를 named tuple로 반환
    var cellInfoTuple: (img: UIImage?, text: String) {
        switch self {
        case .memo:             return (UIImage.memo_Img,       "메모")
        case .date:             return (UIImage.calendar_Img,   "날짜")
        case .time:             return (UIImage.clock_Img,      "시간")
        case .price:            return (UIImage.won_Img,        "금액")
        case .payer:            return (UIImage.person_Img,     "계산")
        case .payment_Method:   return (UIImage.n_Mark_Img,     "정산")
        }
    }
    
    
    
    
    static func validation(dict: [String: Any?]) -> [String] {
        return self.allCases.compactMap { caseItem in
            if caseItem != .payment_Method 
                && !dict.keys.contains(caseItem.databaseString) {
                return caseItem.databaseString
            }
            return nil
        }
    }
    
    
//    static func getDetails(receipt: Receipt?) -> [ReceiptWriteCellVMProtocol] {
//        return self.allCases.map
//        { cellType -> (ReceiptWriteCellVMProtocol) in
//            // MARK: - receipt 의존성 주입
//            return ReceiptWriteDataCellVM(withReceiptEnum: cellType)
//        }
//    }
    
    
    static func getDetails(isReceiptWriteVC: Bool, receipt: Receipt?) -> [ReceiptWriteCellVMProtocol] {
        return self.allCases
            .filter { cellType -> Bool in
                // isReceiptWriteVC가 true일 경우 payment_Method를 제외
                if isReceiptWriteVC 
                    && cellType == .payment_Method {
                    return false
                }
                return true
            }
            .map { cellType -> ReceiptWriteCellVMProtocol in
                // 이제 조건에 맞는 cellType만 가지고 ViewModel을 생성
                return ReceiptWriteDataCellVM(withReceiptEnum: cellType)
            }
    }
    
    private func detail(from receipt: Receipt?) -> String? {
        guard let receipt = receipt else { return nil }
        
         switch self {
         case .memo:
             return receipt.context
         case .date:
             return receipt.date
         case .time:
             return receipt.time
         case .price:
             return NumberFormatter.localizedString(from: NSNumber(value: receipt.price), number: .currency)
         case .payer:
             return receipt.payer
         case .payment_Method:
             return "\(receipt.paymentMethod)"
         }
     }
}


