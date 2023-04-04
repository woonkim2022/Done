//
//  readPlanService.swift
//  Done
//
//  Created by 안현정 on 2022/03/14.
//

import Alamofire
import Foundation

class readPlanService  {
    
    func getData(_ viewcontroller: PlanViewController) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.planURL
 
        print(url)
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding:  URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: readPlanDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("plan 조회 성공하였습니다")
                    viewcontroller.didReadPlanService(result: response.item)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("plan 조회 실패하였습니다.")
                }
            }
    }
    
    

}






