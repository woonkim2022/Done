//
//  CatagoryService.swift
//  Done
//
//  Created by 안현정 on 2022/03/19.
//

import Foundation
import Alamofire


class CatagoryService  {
    
    func getData(_ viewcontroller: CatagoryViewController) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.catagoryURL
 
        print(url)
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding:  URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: CatagoryDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("CatagoryS 조회 성공하였습니다")
                    viewcontroller.didCatagoryService(result: response.item)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("CatagoryS 조회 실패하였습니다.")
                }
            }
    }
    
    

}
