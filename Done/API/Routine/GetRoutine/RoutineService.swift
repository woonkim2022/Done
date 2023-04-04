//
//  RoutineService.swift
//  Done
//
//  Created by 안현정 on 2022/03/13.
//

import Alamofire
import Foundation

class routineService  {

    func getData(_ viewcontroller: RoutineViewController) {

        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")

        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.routineURL

        print(url)

        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding:  URLEncoding.default,
                   headers: headers)

            .validate()
            .responseDecodable(of: routineDataModel.self) { response in

                switch response.result {
                case .success(let response):
                    print(response)
                    print("Routine 조회 성공하였습니다")
                    viewcontroller.didRoutineService(result: response.item)

                case .failure(let error):
                    print(error.localizedDescription)
                    print("Routine 조회 실패하였습니다.")
                    print("routine 조회 실패? --------")

                }
            }
    }



}





