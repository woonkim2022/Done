//
//  doneCountService .swift
//  Done
//
//  Created by 안현정 on 2022/03/09.
//

import Foundation
import Alamofire

class  doneCountService  {

    func getData(_ date: String,_ viewcontroller: CalendarVC) {

        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }

        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.doneCountURL
        let params: Parameters = [
            "yMonth" : "\(date)"
        ]

        print(token)
        
            AF.request(url,
                       method: .get,
                       parameters: params,
                       encoding: URLEncoding.default,
                       headers: headers)

                .validate()
                .responseDecodable(of: doneCountDataModel.self) { response in

                switch response.result {
                case .success(let response):
                    print("DEBUG>> Success \(response) ")
                    viewcontroller.didDoneCountService(response)
             
                case .failure(let error):
                    print("DEBUG>> Error : \(error)")
                    print("DonelistCount -> FAIL 실패하였습니다")
                    print(url)
                }
            }
        }

    }
