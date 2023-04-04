//
//  UIView.swift
//  Done
//
//  Created by 안현정 on 2022/02/25.
//

import UIKit

// UIView 원하는 부분에 line 긋기
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}


extension UIView {
    
    func asImage() -> UIImage {
          let renderer = UIGraphicsImageRenderer(bounds: bounds)
          return renderer.image { rendererContext in
              layer.render(in: rendererContext.cgContext)
          }
      }
    
    @IBInspectable var border2Width: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var corner2Radius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var border2Color: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    
    func viewShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor // 색깔
        layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        layer.shadowRadius = 8 // 반경
        layer.shadowOpacity = 0.3 // alpha값
    }
    
    // 배경 어둡게 만들기
    func setPopupBackgroundView(to superV: UIView) {
        self.backgroundColor = .black
        superV.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superV.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superV.bottomAnchor, constant: 0).isActive = true
        self.leftAnchor.constraint(equalTo: superV.leftAnchor, constant: 0).isActive = true
        self.rightAnchor.constraint(equalTo: superV.rightAnchor, constant: 0).isActive = true
        self.isHidden = true
        self.alpha = 0
        superV.bringSubviewToFront(self)
    }
    
    func animatePopupBackground(_ direction: Bool) {
        let duration: TimeInterval = direction ? 0.35 : 0.20
        let alpha: CGFloat = direction ? 0.40 : 0.0
        self.isHidden = !direction
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
    
}
