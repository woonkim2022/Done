//
//  DeleteRoutineService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Alamofire
import Foundation

class DeleteRoutineService {

    func deleteData(parameter : Int, delegate : AddRoutineViewController) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.routineURL + "/" + String(parameter)

        AF.request(url,
                   method: .delete,
                   parameters: parameter,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:DeleteRoutineDatamodel.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! 루틴 삭제 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print("루틴 삭제 실패하였습니다.")
            }
        }
        
    }
}

