//
//  onBoardingService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Alamofire
import Foundation

class onBoardingService {

    func patchData(_ parameters : onBoardingDatamodel, delegate : TypeVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.profileURL

        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:onBoardingEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! 온보딩 정보 추가 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("온보딩 추가 실패하였습니다")
            }
        }
        
    }
}
