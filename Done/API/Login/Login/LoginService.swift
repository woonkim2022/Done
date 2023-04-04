//
//  LoginService.swift
//  Done
//
//  Created by 안현정 on 2022/02/23.
//

import Alamofire
import Foundation

class LoginService {
    func loginPw() {
        
        let url = APIConstants.loginURL
        let params =  [
            "email" : loginData.email,
            "password": loginData.pw
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder(),
                   headers: nil)
            .validate()
            .responseDecodable(of:loginEntity.self) { response in
                
                switch response.result {
                case .success(let response):
                    print("DEBUG>> Success \(response)")
                    
                    loginData.loginState = response.is_success!
                    print(loginData.loginState)
                    loginData.jwt = response.item?.access_token ?? ""
                    
                    UserDefaults.standard.set(loginData.jwt, forKey: "token")
                    
                    
                    print("로그인결과 \(loginData.loginState)")
                    print("user token -> \(loginData.jwt)")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("로그인 실패하였습니다.")
                    
                    print("실패했을 때 로그인 이메일 -> \(loginData.email)")
                    print(loginData.pw)

                }
            }
        
    }
    
}
