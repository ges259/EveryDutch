//
//  UIImage+Ext.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

extension UIImage {
    
    /// 플러스 버튼 이미지
    static let plus_Img: UIImage? = UIImage(systemName: "plus")
    static let plus_Circle_Img: UIImage? = UIImage(systemName: "plus.circle.fill")
    /// 색상이 있는 사람 표시
    static let person_Fill_Img: UIImage? = UIImage(systemName: "person.crop.circle.fill")
    /// 색상이 없는 사람 표시
    static let person_Img: UIImage? = UIImage(systemName: "person.crop.circle")
    
    /// 채팅방이 없을 때 나오는 이미지
    /// 정산 목록이 없을 때 나오는 이미지
    
    static let memo_Img: UIImage? = UIImage(systemName: "pencil.circle")
    
    /// 셀 삭제 이미지
    static let trash_Img: UIImage? = UIImage(systemName: "trash.circle.fill")
    /// 셀 되살리기 이미지
    static let recycle_Img: UIImage? = UIImage(systemName: "arrow.counterclockwise.circle.fill")
    
    /// 생상이 있는 설정 이미지
    static let gear_Fill_Img: UIImage? = UIImage(systemName: "gearshape.fill")
    /// 생상이 있는 설정 이미지
    static let gear_Img: UIImage? = UIImage(systemName: "gearshape")
    /// 채팅방 나가기 이미지
    static let Exit_Img: UIImage? = UIImage(systemName: "rectangle.portrait.and.arrow.right")
    /// 초대하기 이미지
    static let Invite_Img: UIImage? = UIImage(systemName: "person.crop.circle.fill.badge.plus")
    /// 선택 안 된 상태의 사각형
    static let empty_Square_Img: UIImage? = UIImage(systemName: "square")
    /// 선택 된 상태의 사각형 + 체크 표시
    static let check_Square_Img: UIImage? = UIImage(systemName: "checkmark.square.fill")
    /// 생상이 있는 원
    static let empty_Circle_Img: UIImage? = UIImage(systemName: "circle")
    static let circle_Fill_Img: UIImage? = UIImage(systemName: "circle.fill")
    /// 시계 이미지
    static let clock_Img: UIImage? = UIImage(systemName: "clock")
    /// 메모 이미지
    static let note_Img: UIImage? = UIImage(systemName: "square.and.pencil")
    /// 원(Won) 이미지
    static let won_Img: UIImage? = UIImage(systemName: "wonsign.circle")
    /// 신용카드 이미지
    static let card_Img: UIImage? = UIImage(systemName: "creditcard.circle")
    /// 정산 (n) 이미지
    static let n_Mark_Img: UIImage? = UIImage(systemName: "n.circle")
    /// 달력 이미지
    static let calendar_Img: UIImage? = UIImage(systemName: "calendar.circle")
    /// 체크 표시
    static let checkmark_Img: UIImage? = UIImage(systemName: "checkmark")
    static let chevronLeft: UIImage? = UIImage(systemName: "chevron.left")
    static let chevronRight: UIImage? = UIImage(systemName: "chevron.right")
    static let arrow_down: UIImage? = UIImage(systemName: "arrow.down.circle.fill")
    static let menu_Img: UIImage? = UIImage(systemName: "line.3.horizontal")
    
    // 개인_ID 복사 이미지
    static let copy_Img: UIImage? = UIImage(systemName: "doc.on.clipboard.fill")
    static let record_Img: UIImage? = UIImage(systemName: "tray.full")
    static let settlement_Img: UIImage? = UIImage(systemName: "doc.text.fill")
    static let x_Mark_Img: UIImage? = UIImage(systemName: "xmark")
}










extension UIImage {
    // MARK: - 이미지를 아래 방향으로 고정
    func fixedOrientation() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        // 이미지의 방향이 이미 올바른 경우 바로 반환
        if self.imageOrientation == .up {
            return self
        }

        var transform = CGAffineTransform.identity

        // 이미지의 방향에 따른 변환 설정
        switch self.imageOrientation {
        case .down, .downMirrored:
            // 아래쪽으로 향한 이미지를 180도 회전
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            // 왼쪽으로 향한 이미지를 90도 시계 방향으로 회전
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            // 오른쪽으로 향한 이미지를 90도 반시계 방향으로 회전
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
        case .up, .upMirrored:
            break
        @unknown default:
            return self
        }

        // 좌우 반전된 이미지 처리
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            // 상하 반전
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            // 좌우 반전
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            return self
        }

        // 색상 공간 설정
        guard let colorSpace = cgImage.colorSpace else { return nil }
        // 컨텍스트 생성
        guard let context = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }

        // 변환 적용
        context.concatenate(transform)

        // 이미지 그리기
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // 가로와 세로를 바꿔서 그리기
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            // 원래 크기로 그리기
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }

        // 새로운 이미지 생성
        guard let newCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage)
    }
}












extension UIImage {
    func toCIImage() -> CIImage? {
        return self.ciImage ?? CIImage(cgImage: self.cgImage!)
    }
}


internal extension CIImage {
    func toUIImage() -> UIImage {
        /*
            If need to reduce the process time, than use next code.
            But ot produce a bug with wrong filling in the simulator.
            return UIImage(ciImage: self)
         */
        let context: CIContext = CIContext.init(options: nil)
        let cgImage: CGImage = context.createCGImage(self, from: self.extent)!
        let image: UIImage = UIImage(cgImage: cgImage)
        return image
    }
    
    func toCGImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return cgImage
        }
        return nil
    }
}
