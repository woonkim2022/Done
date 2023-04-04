//
//  getTypeService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Foundation
import Alamofire
import UIKit

class getTypeService {
    
    func getData(_ viewcontroller: MyVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
         
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.typeURL

        AF.request(url,
                   method: .get,
                   parameters: nil,
                  // encoding: URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: getTypeDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("기록 유형 조회 성공하였습니다")
                    viewcontroller.didUserTypeService(response)


                case .failure(let error):
                    print(error.localizedDescription)
                    print("기록 유형 실패하였습니다.")
                    print(response.result)

                }
            }
    }
    
    

}

