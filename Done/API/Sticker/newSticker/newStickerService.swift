//
//  newStickerService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Foundation
import Alamofire

class newStickerService {
    
    func getData(_ viewcontroller: CalendarVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.newStickerURL

        AF.request(url,
                   method: .get,
                   parameters: nil,
                  // encoding: URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: newStickerDatamodel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("새로운 스티커 조회 성공하였습니다")
                    viewcontroller.didNewStickerService(response)


                case .failure(let error):
                    print(error.localizedDescription)
                    print("새로운 스티커 조회 실패하였습니다.")
                    print(response.result)

                }
            }
    }
    
    

}


