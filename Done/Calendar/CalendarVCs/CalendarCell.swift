//
//  CalendarCell.swift
//  Done
//
//  Created by 안현정 on 2022/02/26.
//

import UIKit
import FSCalendar
import SwiftUI
import SnapKit



enum SelectionType: Int {
    case none
    case single
    case gray
}

class CalendarCell: FSCalendarCell {

    let gregorian = Calendar.current //캘린더 현재 날짜
    weak var circleImage: UIImageView! //캘린더에 들어갈 이미지
    weak var stickerImage: UIImageView! //캘린더에 들어갈 이미지

    var countLabel: UILabel!
    var dateString = ["1","2","3"]
    weak var delegate: calendarDelegate?


    var width: CGFloat = 32.0 {
        didSet { //프로퍼티 값 이 변경되기 직전
            setNeedsLayout()
            // View의 layout의 재설정이 필요하다는 것을 시스템에게 알려줌
            // updateCycle에 layout을 업데이트
        }
    }
    
    var yPosition: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    

    var cellDate: Date? {
        didSet {
            indicateToday(date: cellDate!)
        }
    }
    


    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
                commonInit()
    }

    // 캘린더 bottom line 선 긋기
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
  
        
        let circleImageView = UIImageView(image: UIImage(named: "스티커"))
        let stickerImage = UIImageView(image: UIImage(named: "스티커"))

        let countlabel = UILabel(frame: CGRect(x: self.preferredImageOffset.x, y: self.preferredImageOffset.y, width: self.contentView.fs_width, height: self.contentView.fs_height))
        countlabel.text = ""
        countlabel.textColor = UIColor.black
        self.contentView.insertSubview(countlabel, at: 0)
        self.contentView.insertSubview(circleImageView, at: 0) // view1을 0번째에 삽입
        self.contentView.insertSubview(stickerImage, at: 0) // view1을 0번째에 삽입
        self.contentView.bringSubviewToFront(countlabel)
        self.countLabel = countlabel
        self.circleImage = circleImageView
        self.stickerImage = stickerImage
        self.layer.addBorder([.top], color: UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0), width: 1.0)


    }
    
  //  CGRectMake(self.preferredImageOffset.x, self.preferredImageOffset.y, self.contentView.fs_width, self.contentView.fs_height)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.countLabel.snp.makeConstraints {
            $0.top.equalTo(self.stickerImage.snp.bottom).offset(-22)
         //   $0.top.equalTo(self.stickerImage.snp.bottom).offset(-20)
            $0.leading.equalTo(self.stickerImage).offset(10)
            }
        
        
        let width = width
        let yPosition = yPosition
        let distance = (self.contentView.bounds.width - width) / 2
        let frame = CGRect(x: self.contentView.bounds.minX + distance,
                           y: self.contentView.bounds.minY + yPosition,
                           width: width,
                           height: width)
        let frame3 = CGRect(x: self.contentView.bounds.minX + distance,
                           y: self.contentView.bounds.minY + 40,
                           width:  30,
                           height: 29)
        self.circleImage.frame = frame
        //self.countLabel.frame = frame2
        self.stickerImage.frame = frame3

        
        
        switch selectionType {
        case .none:
            self.countLabel.text = ""
            self.stickerImage.image = nil
        case .single:
            //self.countLabel.text = ""
            self.countLabel.textColor = .white
            self.countLabel.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 14)
            self.stickerImage.image = UIImage(named: "sticker")
        case .gray:
            //self.countLabel.text = ""
            self.countLabel.textColor = .white
            self.countLabel.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 14)
            self.stickerImage.image = UIImage(named: "회색스티커")
        }

    }


    // MARK: - Helpers

    // '오늘날짜' 커스텀
    private func indicateToday(date: Date) {
        if self.gregorian.isDateInToday(date) {
            self.titleLabel.textColor = UIColor.black
            self.titleLabel.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 15)
            self.circleImage.image = UIImage(named: "todayDot")
        } else {
            self.circleImage.image = nil
        }
    }
    


    
    private func commonInit() {
        self.shapeLayer.isHidden = true
               let view = UIView(frame: self.bounds)
               self.backgroundView = view
    }
    


}
