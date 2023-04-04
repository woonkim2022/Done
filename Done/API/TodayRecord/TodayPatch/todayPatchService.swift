//
//  todayPatchService.swift
//  Done
//
//  Created by 안현정 on 2022/03/28.
//

import Alamofire
import Foundation

class todayPatchService {

    func patchData(_ parameters : todayPatchDataModel, delegate : TodayRecordVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.todayRecordURL + "/" + String(delegate.todayNumber)
        print("수정 url \(url)")

        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:todayPatchEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! 오늘한마디 수정 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("오늘한마디 수정 실패하였습니다.")
            }
        }
        
    }
}

