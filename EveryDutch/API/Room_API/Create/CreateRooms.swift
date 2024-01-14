//
//  CreateRooms.swift
//  EveryDutch
//
//  Created by 계은성 on 1/9/24.
//

import Foundation


struct RoomsAPI {
    static let shared: RoomsAPI = RoomsAPI()
    private init() {}
}


extension RoomsAPI {
    
}


// Create
    // 방 생성 ----- (Rooms_Thumbnail)
        // 생성자의 데이터 저장 ----- (Rooms_ID)
        // 호출: Version_API에서 버전 만들기 ----- (Version_Thumbnail)
    
    
// Read
    // 앱 실행 시
        // 자신이 속한 방 가져오기 ----- (Rooms_ID)
        // user - 방 데이터 가져오기 ----- (Rooms_Thumbnail)
    // 방에 들어섰을 때
        // 방 유저 데이터 가져오기 ----- (Room_Users)
    // 누적 금액 가져오기

// Update
    // 방에 초대 ----- (Rooms_ID)
    // 방 개인 정보 수정 ----- (Rooms_Thumbnail)
        // - user의 이름 바꾸기
        // - user의 이미지 바꾸기
    // 방 정보 수정 ----- (Rooms_Thumbnail)
        // - 방의 이름 바꾸기
        // - 방의 이미지 바꾸기
    // 영수증 작성 시 금액 변경 ----- (Room_Money_Data)
        // - 누적 금액 변경
        // - 받아야 할 돈 변경

// Delete
    // 방에서 나가기 ----- (Room_ID)
        // 강퇴
    // 방에서 모두 나가기
        // 방 삭제
        // 호출: Version_API에서 버전 삭제 ----- (Version_Thumbnail)


