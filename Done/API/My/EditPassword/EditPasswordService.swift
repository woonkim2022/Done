//
//  EditPasswordService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//


import Alamofire
import Foundation

class editPasswordService {
    func postDatamanager(_ parameters : EditdataModel, delegate : editPasswordVC)  {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.passwordURL
   
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:EditPasswordEntity.self) { response in
                
                switch response.result {
                case .success(let response):
                    print("DEBUG>> Success 비밀번호 변경 \(response)")
            
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("비밀번호 변경 실패하였습니다.")
                    print(error)

                }
            }
    }
    
}
