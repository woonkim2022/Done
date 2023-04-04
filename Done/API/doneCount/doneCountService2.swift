//
//  doneCountService2.swift
//  Done
//
//  Created by 안현정 on 2022/03/25.
//



import Foundation
import Alamofire

class  doneCountService2  {

    func getData(_ date: String,_ viewcontroller: DoneVC) {

        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }

        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.doneCountURL
        let params: Parameters = [
            "yMonth" : "\(date)"
        ]

            AF.request(url,
                       method: .get,
                       parameters: params,
                       encoding: URLEncoding.default,
                       headers: headers)

                .validate()
                .responseDecodable(of: doneCountDataModel.self) { response in

                switch response.result {
                case .success(let response):
                    viewcontroller.didDoneCountService(response)
             
                case .failure(let error):
                    print("DEBUG>> Error : \(error)")
                    print(url)
                }
            }
        }

    }
