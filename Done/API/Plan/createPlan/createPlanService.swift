//
//  createPlanService.swift
//  Done
//
//  Created by 안현정 on 2022/03/15.
//

import Alamofire
import Foundation

class createPlanService {

    func postData(_ parameters : CreatePlanDataModel, delegate : PlanTextVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.planURL

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:createPlanEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> 플랜작성 Success \(response)")
        
                
            case .failure(let error):
                print(error.localizedDescription)
                print("플랜 작성 실패하였습니다.")
            }
        }
        
    }
}
