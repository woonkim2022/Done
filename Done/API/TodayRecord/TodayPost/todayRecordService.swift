//
//  todayRecordService.swift
//  Done
//
//  Created by 안현정 on 2022/03/28.
//

import Foundation
import Alamofire

class todayRecordService {

    func postData(_ parameters : todayRecordDataModel, delegate : TodayRecordVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.todayRecordURL
        print(url)

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:todayRecordEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print(error)
                print("오늘 한마디 작성 실패하였습니다.")
            }
        }
        
    }
}
