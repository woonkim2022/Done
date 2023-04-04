//
//  doneCreateService.swift
//  Done
//
//  Created by 안현정 on 2022/03/05.
//

import Alamofire
import Foundation

class doneCreateService {

    func postData(_ parameters : doneCreateDataModel, delegate : DoneTextVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.doneCreateURL

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:doneCreateEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("Done 작성 실패하였습니다.")
            }
        }
        
    }
}
