//
//  WithdrawalService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Alamofire
import Foundation

class WithdrawalService {

    func deleteData() {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.profileURL

        AF.request(url,
                   method: .delete,
                  // parameters: parameter,
                  // encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:WithdrawalEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! 회원탈퇴 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("회원탈퇴 실패하였습니다.")
            }
        }
        
    }
}

