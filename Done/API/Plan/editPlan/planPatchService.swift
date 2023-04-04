//
//  planPatchService.swift
//  Done
//
//  Created by 안현정 on 2022/03/26.
//



import Alamofire
import Foundation

class planPatchService {

    func patchData(_ parameters : planPatchDataModel, delegate : PlanTextVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.planURL + "/" + String(delegate.planNo)
        print("donePatchService\(url)")

        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:planPatchEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! 플랜 수정 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print(error)
                print(" 플랜 수정 실패하였습니다.")
            }
        }
        
    }
}

