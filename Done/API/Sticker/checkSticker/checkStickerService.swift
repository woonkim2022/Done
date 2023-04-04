//
//  checkStickerService.swift
//  Done
//
//  Created by 안현정 on 2022/04/01.
//

import Alamofire
import Foundation

class checkStickerService {

    func getData(parameter: Int , delegate : getStickerPopupVC) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.allStickerURL + "/\(parameter)"

        print(url)
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder(),
                   headers: headers)
            .validate()
            .responseDecodable(of:checkStickerEntity.self) { response in
                
            switch response.result {
            case .success(let response):
                print("DEBUG>> 스티커 확인 Success \(response)")
        
                
            case .failure(let error):
                print(error.localizedDescription)
                print(response.result)
                print("스티커 확인 실패하였습니다.")
            }
        }
        
    }
}
