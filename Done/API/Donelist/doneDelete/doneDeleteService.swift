//
//  doneDeleteService.swift
//  Done
//
//  Created by 안현정 on 2022/03/21.
//

import Alamofire
import Foundation

class doneDeleteService {

    func deleteData(parameter : Int, delegate : DoneVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.doneCreateURL + "/\(parameter)"

        AF.request(url,
                   method: .delete,
                   parameters: parameter,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:doneDeleteDataModel.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! donelist 삭제 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("Donelist 삭제 실패하였습니다.")
            }
        }
        
    }
}

