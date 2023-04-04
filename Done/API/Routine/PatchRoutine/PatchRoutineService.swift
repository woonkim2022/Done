//
//  PatchRoutineService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//
import Alamofire
import Foundation

class PatchRoutineService {

    func patchData(_ parameters : PatchRoutineDatamodel, delegate : RoutineTextViewController) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.routineURL + "/" + String(delegate.routineNo)
        print("donePatchService\(url)")

        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:PatchRoutineEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> Success! 루틴 수정 성공했습니다 \(response)")
                
            case .failure(let error):
                print(error.localizedDescription)
                print(error)
                print(" 루틴 수정 실패하였습니다.")
            }
        }
        
    }
}

