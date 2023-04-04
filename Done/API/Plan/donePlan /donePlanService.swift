//
//  donePlanService.swift
//  Done
//
//  Created by 안현정 on 2022/03/16.
//

import Alamofire
import Foundation

class donePlanService {

    func postData(parameter: Int , delegate : PlanViewController) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.planURL + "/\(parameter)"

        print(url)
        
        let params =  [
            "date" : delegate.fommetDate
        ]
        
        print(params)
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:donePlanDataModel.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> 플랜 실행 Success \(response)")
        
                
            case .failure(let error):
                print(error.localizedDescription)
                print(response.result)
                print("플랜 실행 실패하였습니다.")
            }
        }
        
    }
}
