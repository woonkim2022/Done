//
//  LoginPwService.swift
//  Done
//
//  Created by 안현정 on 2022/02/22.
//

import Alamofire
import Foundation

class signupService {
    
    func signup() {
    let url = APIConstants.signupURL
    let params =  [
        "email" : signupData.email,
        "password": signupData.pw
    ]
    
    AF.request(url,
               method: .post,
               parameters: params,
               encoder: JSONParameterEncoder(),
               headers: nil)
        .validate()
        .responseDecodable(of:signupEntity.self) { response in
            
        switch response.result {
        case .success(let response):
            print("DEBUG>> Success \(response)")
            signupData.signupState = response.is_success!
            print("회원가입 상태 >> \(signupData.signupState)")
            
        case .failure(let error):
            print(error.localizedDescription)
            print("회원가입 실패하였습니다")
        }
    }
    
}

}
