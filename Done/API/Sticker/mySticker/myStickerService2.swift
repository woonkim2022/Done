//
//  myStickerService2.swift
//  Done
//
//  Created by 안현정 on 2022/03/30.
//

import Alamofire
import Foundation
import UIKit

class myStickerService2 {
    
    func getData(_ viewcontroller: CalendarVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }

        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.stickerURL
 
    
        AF.request(url,
                   method: .get,
                   parameters: nil,
                  // encoding: URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: myStickerDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("내 스티커 조회 성공하였습니다")
                    viewcontroller.didStickerService(response)


                case .failure(let error):
                    print(error.localizedDescription)
                    print("내 스티커 조회 실패하였습니다.")
                    print(response.result)

                }
            }
    }
    
    

}








