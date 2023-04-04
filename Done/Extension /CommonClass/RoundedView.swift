//
//  RoundedView.swift
//  Done
//
//  Created by 안현정 on 2022/03/12.
//


import UIKit

@IBDesignable
class RoundedView: UIView, Roundable {
    @IBInspectable var isCircle: Bool = false {
        didSet {
            setupLayer()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setupLayer()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setupLayer()
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            setupLayer()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayer()
    }
}
