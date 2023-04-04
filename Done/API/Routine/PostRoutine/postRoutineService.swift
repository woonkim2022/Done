//
//  postRoutineService.swift
//  Done
//
//  Created by 안현정 on 2022/03/17.
//


import Alamofire
import Foundation

class postRoutineService {

    func postData(_ parameters : postRoutineDataModel, delegate : RoutineTextViewController) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.routineURL

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:postRoutineEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> 루틴 작성 Success \(response)")
        
                
            case .failure(let error):
                print(error.localizedDescription)
                print("루틴 작성 실패하였습니다.")
            }
        }
        
    }
}

