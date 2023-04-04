//
//  allStickerService.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import Alamofire
import Foundation
import UIKit

class allStickerService {
    
    func getData(_ viewcontroller: StickerVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }

        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.allStickerURL
 
        print(url)
        
        let params =  [
            "classify" : "공통"
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                  // encoding: URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: allStickerDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("전체 스티커 조회 성공하였습니다")
                    viewcontroller.didAllStickerService(response)


                case .failure(let error):
                    print(error.localizedDescription)
                    print("전체 스티커 조회 실패하였습니다.")
                    print(response.result)

                }
            }
    }
    
    

}








