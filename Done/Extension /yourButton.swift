//
//  UIButton.swift
//  Done
//
//  Created by 안현정 on 2022/02/15.
//

import UIKit

//버튼 모서리 둥글게 만들기

@IBDesignable
class yourButton : UIButton {
    
    open override var isEnabled: Bool{
          didSet {
              alpha = isEnabled ? 1.0 : 1.0
          }
      }
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    
}


extension UIButton {
    
    func setUnderline() {
         guard let title = title(for: .normal) else { return }
         let attributedString = NSMutableAttributedString(string: title)
         attributedString.addAttribute(.underlineStyle,
                                       value: NSUnderlineStyle.single.rawValue,
                                       range: NSRange(location: 0, length: title.count)
         )
         setAttributedTitle(attributedString, for: .normal)
     }
    
    //버튼 그림자 넣기
    func shadow() {
        layer.shadowColor = UIColor.lightGray.cgColor // 색깔
        layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        layer.shadowRadius = 8 // 반경
        layer.shadowOpacity = 0.3 // alpha값
    }
    
    
    func lineSet(){
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func blueLineSet(){
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0).cgColor
    }
    
    func circleSet() {
        layer.cornerRadius = layer.frame.size.width/2
        clipsToBounds = true
    }
    
    
    
    
    func attributedTitle(firstPart: String, secondPart: String) {
          //NSAttributedString 문자열 객체는 부분적으로 각기 다른 세부 텍스트 설정 가능
          //1. 한 글자에 여러개의 Attributes가 적용될 수 있기 때문에, [NSAttributedString.Key: Any] 타입의 Dictionary 사용
          let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(cgColor: #colorLiteral(red: 0.9963282943, green: 0.4081644416, blue: 0.4202112854, alpha: 1))] //문자열 속성
          
          //2. title을 NSMutableAttributedString로 바꿔서 attributedTitle에 저장
          //attributedTitle 옵션을 추가하고 수정할 것이기 때문에 변경가능한 NSMutableAttributedString 개체 이용
          //firstPart를 따음표로 묶어주는 이유는 뒤에 스페이스바 처리를 해줘야하기 때문에
          let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: atts)
          
          let colorAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(cgColor: #colorLiteral(red: 0.6235901713, green: 0.6195495129, blue: 0.6847336888, alpha: 1))] //문자열 속성
          attributedTitle.append(NSAttributedString(string: secondPart, attributes: colorAtts))

          //3. setAttributedTitle을 이용해 UIButton에 적용
          setAttributedTitle(attributedTitle, for: .normal)
      }
      
}
