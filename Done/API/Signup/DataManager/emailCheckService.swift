//
//  emailCheckService.swift
//  Done
//
//  Created by 안현정 on 2022/02/22.
//

import Alamofire
import Foundation

class emailCheckService {
    
   // static let shared = emailCheckService()
    
    func emailCheck() {
        
        let url = "\(APIConstants.baseURL)/api/auth/check-email"
        let params =  [
            "email" : emailCheckData.email
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder(),
                   headers: nil)
            .validate()
            .responseDecodable(of:emailCheckEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success \(response)")
                emailCheckData.emailState = response.is_success!
                
               // UserDefaults.standard.setValue(email, forKey: "email")
              
//                LoginResponse.ResponseState = response.isSuccess!
//                LoginResponse.ResponseJwt = response.result?.jwt ?? ""
//                LoginResponse.ResponseUserIdx = response.result?.userIdx ?? 0
//                print("로그인성공했다 이거는 인덱스값이다\(LoginResponse.ResponseUserIdx)")
//                print("jwt값!!!!!!!\(LoginResponse.ResponseJwt)")
                
                
                
            case .failure(let error):
                print(error.localizedDescription)
                print("이메일 중복체크 실패하였습니다")
            }
        }
        
    }
}
