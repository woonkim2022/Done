//
//  EditTypeService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Alamofire
import Foundation

class EditTypeService {

    func patchData() {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.typeURL

        AF.request(url,
                   method: .patch,
                 //  parameters: parameters,
                 //  encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:EditNicknameEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! 기록 유형 변경 되었습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("기록 유형 변경  실패하였습니다")
            }
        }
        
    }
}
