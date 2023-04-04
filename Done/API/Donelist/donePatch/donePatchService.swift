//
//  donePatchService.swift
//  Done
//
//  Created by 안현정 on 2022/03/20.
//


import Alamofire
import Foundation

class donePatchService {

    func patchData(_ parameters : donePatchDataModel, delegate : DoneTextVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.doneCreateURL + "/" + String(delegate.doneNo)
        print("donePatchService\(url)")

        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:donePatchEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! donelist 수정 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("Donelist 수정 실패하였습니다.")
            }
        }
        
    }
}

