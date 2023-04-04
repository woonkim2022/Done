//
//  profileService.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//


import Alamofire
import Foundation
import UIKit

class profileService {
    
    func getData(_ viewcontroller: MyVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
 
        print("token -------- \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.profileURL

        AF.request(url,
                   method: .get,
                   parameters: nil,
                  // encoding: URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: profileDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("내 프로필 조회 성공하였습니다")
                    viewcontroller.didProfileService(response)


                case .failure(let error):
                    print(error.localizedDescription)
                    print("내 프로필 조회 실패하였습니다.")
                    print(response.result)

                }
            }
    }
    
    

}

