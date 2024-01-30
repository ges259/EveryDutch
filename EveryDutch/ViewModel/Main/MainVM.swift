//
//  MainVM.swift
//  EveryDutch
//
//  Created by 계은성 on 2023/12/25.
//

import UIKit

final class MainVM: MainVMProtocol {
    
    // MARK: - 모델
    private var cellViewModels: [MainCollectionViewCellVM] = []
    
    // 1. 데이터를 받아서 cellViewModel에 넣는다.
    private var rooms: [Rooms] = []
//    var roomsAPI: RoomsAPIProtocol
    
    
    
    
    
    
    
    
    // MARK: - 방의 개수
    var numberOfItems: Int {
        return self.cellViewModels.count
    }
    
    // MARK: - 컬렉션뷰 클로저
    var collectionVeiwReloadClousure: (() -> Void)?
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var roomDataManager: RoomDataManagerProtocol
    
    // MARK: - 라이프 사이클
    init(roomDataManager: RoomDataManagerProtocol) {
        self.roomDataManager = roomDataManager
        
        // '방'의 모든 데이터 가져오기
        self.getRoomsData()
    }
    deinit {
        print("\(#function)-----\(self)")
    }
    
    
    
    // MARK: - 아이템이 눌렸을 때
    func itemTapped(index: Int) {
        self.roomDataManager.currentRooms(index: index)
    }
    
    
    
    // MARK: - 플로팅 버튼 상태
    private var isFloatingShow: Bool = false
    
    // MARK: - 플로팅 버튼 클로저
    var onFloatingShowChanged: ((floatingType) -> Void)?
    
    
    // MARK: - 플로팅 버튼 Alpha
    private var getBtnAlpha: CGFloat {
        return self.isFloatingShow
        ? 1
        : 0
    }
    // MARK: - 플로팅 버튼 상태 여부
    var getIsFloatingStatus: Bool {
        return self.isFloatingShow
    }
    
    // MARK: - 플로팅 버튼 위치 변경
    var getBtnTransform: CGAffineTransform {
        return self.isFloatingShow
        ? CGAffineTransform.identity
        : CGAffineTransform(translationX: 0, y: 80)
    }
    
    // MARK: - 메뉴 버튼 회전
    var getSpinRotation: CGAffineTransform {
        return self.isFloatingShow
        ? CGAffineTransform(rotationAngle: .pi - (.pi / 4))
        : CGAffineTransform.identity
    }
    
    // MARK: - 메뉴 버튼 이미지
    var getMenuBtnImg: UIImage? {
        return self.isFloatingShow
        ? UIImage.plus_Img
        : UIImage.menu_Img
    }
    
    // MARK: - 플로팅 버튼 토글
    func toggleFloatingShow() {
        self.isFloatingShow.toggle()
        // 클로저 실행
        self.floatinBtnClosure()
    }
    
    // MARK: - 플로팅 클로저 실행
    private func floatinBtnClosure() {
        let show: Bool = self.getIsFloatingStatus
        let alpha: CGFloat = self.getBtnAlpha
        
        self.onFloatingShowChanged?((show, alpha))
    }
}
    
    
    
    
    
    
    
    
 
// MARK: - API

extension MainVM {
    
    // MARK: - [API] 방의 데이터
    private func getRoomsData() {
        self.rooms = self.roomDataManager.getRooms
        self.makeCellViewModel()
    }
}
    
    
    
    
    
    
    
    


// MARK: - 셀 설정

extension MainVM {
    
    // MARK: - 셀의 데이터 만들기
    private func makeCellViewModel() {
        // 예시 데이터 로드
        self.cellViewModels = self.rooms.map {
            MainCollectionViewCellVM(title: $0.roomName,
                                     imgUrl: $0.roomImg )
        }
        self.collectionVeiwReloadClousure?()
    }
    
    
    // MARK: - 셀의 데이터 반환
     func cellViewModel(at index: Int) -> MainCollectionViewCellVM {
         return self.cellViewModels[index]
     }
}
