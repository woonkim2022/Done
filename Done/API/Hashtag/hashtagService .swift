//
//  hashtagService .swift
//  Done
//
//  Created by 안현정 on 2022/03/12.
//


import Alamofire
import Foundation

// 1. 날짜 userdefault로 저장
// 2. userdefault 불러와서 파라미터 값 넣어주기
// 3. url 값 넣어주기

class hashtagService  {
    
    func getData(_ viewcontroller: HashtagViewController) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String  else { return }
        print("token : \(token)")
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let url = APIConstants.tagURL
 
        print(url)
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding:  URLEncoding.default,
                   headers: headers)
        
            .validate()
            .responseDecodable(of: hashtagDataModel.self) { response in
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("hashtag 조회 성공하였습니다")
                    viewcontroller.didhashtagService(result: response.item)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("hashtag 조회 실패하였습니다.")
                }
            }
    }
    
    

}





