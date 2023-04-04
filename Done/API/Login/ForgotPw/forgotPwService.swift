//
//  forgotPwService.swift
//  Done
//
//  Created by 안현정 on 2022/02/23.
//

import Alamofire
import Foundation

class forgotPwService {
    func postDatamanager() {
        
        let url = APIConstants.forgotPWURL
        let params =  [
            "email" : forgotEmailData.email
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder(),
                   headers: nil)
            .validate()
            .responseDecodable(of:forgotEntity.self) { response in
                
                switch response.result {
                case .success(let response):
                    print("DEBUG>> Success \(response)")
        
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("로그인 실패하였습니다.")
 
                }
            }
        
    }
    
}
