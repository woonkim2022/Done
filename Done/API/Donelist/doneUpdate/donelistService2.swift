//
//  donelistService2.swift
//  Done
//
//  Created by 안현정 on 2022/03/31.
//

import Alamofire
import Foundation
import UIKit
// 1. 날짜 userdefault로 저장
// 2. userdefault 불러와서 파라미터 값 넣어주기
// 3. url 값 넣어주기

class donelistService2 {
    
    func getData(_ viewcontroller: CalendarVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }

        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.doneCreateURL
 
        print(url)
        print(token)
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                  // encoding: URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: donelistDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    //  print(response)
                    print("던리스트 전체조회 성공하였습니다")
                  //  viewcontroller.didAllDonelistService(response)


                case .failure(let error):
                    print(error.localizedDescription)
                    print("Donelist 조회 실패하였습니다.")
                   // print(response.result)

                }
            }
    }
    
    

}
