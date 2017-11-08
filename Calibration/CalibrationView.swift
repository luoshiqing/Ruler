//
//  CalibrationView.swift
//  Calibration
//
//  Created by lsq on 2017/11/8.
//  Copyright © 2017年 罗石清. All rights reserved.
//

import UIKit

class CalibrationView: UIView, UIScrollViewDelegate {
    
    public var valueHandle: ((Float)->Swift.Void)?

    //刻度最大值，默认为30
    public var max = 30
    //刻度最小值，默认为0
    fileprivate var min = 0
    //刻度间距，默认为4
    public var space: CGFloat = 4.0
    //每段刻度的个数，默认为10个
    fileprivate var count = 10
    //刻度的宽度
    public var calibrationWidth: CGFloat = 1.0
    //背景颜色
    public var backColor = UIColor.groupTableViewBackground
    //长刻度颜色
    public var longColor = UIColor.black
    //短刻度颜色
    public var shortColor = UIColor.black
    //指示刻度颜色
    public var indicationColor = UIColor.red
    
    //长刻度高度
    fileprivate lazy var longHeigh: CGFloat = {
        if self.frame.height > 20 {
            return self.frame.height - 20
        }else{
            return self.frame.height / 3.0 * 2.2
        }
    }()
    //短刻度高度
    fileprivate lazy var shortHeigh: CGFloat = {
        return self.longHeigh / 2.0
    }()
    public var animation = true//是否添加动画
    public var showValue: CGFloat = 0{
        didSet{
            
            let value = self.setDefualt(value: showValue)
            
            let w = self.calibrationWidth + space
            let str = String(format: "%.1f", value)
            let setOffsetX = CGFloat(Float(str)!) * CGFloat(self.count) * w
            
            if self.animation {
                UIView.animate(withDuration: 0.45, delay: 0, options: .curveLinear, animations: {
                    self.myScrollView.contentOffset.x = setOffsetX
                }, completion: nil)
            }else{
                self.myScrollView.contentOffset.x = setOffsetX
            }
        }
    }
    fileprivate var myScrollView = UIScrollView()
    public func show(value: CGFloat?, animation: Bool){
        self.loadSomeView()
        self.animation = animation
        self.showValue = self.setDefualt(value: value)
        
    }

    //设置初始默认值
    fileprivate func setDefualt(value: CGFloat?)->CGFloat{
        var endValue: CGFloat = 0
        if let v = value {
            if v > CGFloat(self.max) {
                endValue = CGFloat(self.max)
            }else if v < CGFloat(self.min){
                endValue = CGFloat(self.min)
            }else{
                endValue = v
            }
        }
        return endValue
    }
    //开始绘制图形
    fileprivate func loadSomeView(){
        
        myScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        myScrollView.backgroundColor = self.backColor
        myScrollView.showsVerticalScrollIndicator = false
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.delegate = self
        myScrollView.bounces = false
        self.addSubview(myScrollView)
        
        //添加刻度指示
        let indicationView = UIView(frame: CGRect(x: self.frame.width / 2, y: 0, width: self.calibrationWidth, height: self.frame.height))
        indicationView.backgroundColor = self.indicationColor
        self.addSubview(indicationView)
  
        var allWidht: CGFloat = 0
        for i in 0..<self.max{
            
            for j in 0..<self.count{
                
                let index = i * self.count + j
                
                let x = CGFloat(index) * (self.calibrationWidth + space) + self.frame.width / 2
                
                var height: CGFloat = 0
                var color = self.longColor
                if j % self.count == 0{
                    height = self.longHeigh
                    color = self.longColor
                    //添加label
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                    label.text = "\(i)"
                    label.textColor = UIColor.blue
                    label.font = UIFont.systemFont(ofSize: 14)
                    label.sizeToFit()
                    label.frame.origin.y = height + 2
                    label.center.x = x + self.calibrationWidth / 2
                    myScrollView.addSubview(label)
                }else{
                    height = self.shortHeigh
                    color = self.shortColor
                }
                
                
                let line = UIView(frame: CGRect(x: x, y: 0, width: self.calibrationWidth, height: height))
                line.backgroundColor = color
                myScrollView.addSubview(line)
                
                if index == (self.max * self.count - 1) {
                    //最后一个，记录位置
                    allWidht = line.frame.width + line.frame.origin.x
                }
            }
        }
        
        //补齐最后一个标尺
        let line = UIView(frame: CGRect(x: allWidht + self.space, y: 0, width: self.calibrationWidth, height: self.longHeigh))
        line.backgroundColor = self.longColor
        myScrollView.addSubview(line)
        //文字刻度
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "\(self.max)"
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.frame.origin.y = line.frame.origin.y + line.frame.height + 2
        label.center.x = line.frame.origin.x + line.frame.width / 2.0
        myScrollView.addSubview(label)
        
        let endWidth = line.frame.width + line.frame.origin.x + self.frame.width / 2 - self.calibrationWidth
        myScrollView.contentSize = CGSize(width: endWidth, height: 0)
        
        //补前段空余
        self.addFront()
        //补后段空余
        self.addEnd()
    }
    
    
    //补前段空余
    fileprivate func addFront(){
        //计算有多少个
        let w = self.frame.width / 2
        let count = Int(w / (self.calibrationWidth + space))
        for i in 0...count{
            let x = w - (space + self.calibrationWidth) * CGFloat(i)
            if i != 0{
                var height: CGFloat = 0
                if i % self.count == 0{
                    height = self.longHeigh
                }else{
                    height = self.shortHeigh
                }
                let line = UIView(frame: CGRect(x: x, y: 0, width: self.calibrationWidth, height: height))
                line.backgroundColor = UIColor.lightGray
                self.myScrollView.addSubview(line)
            }
        }
    }
    //补后段空余
    fileprivate func addEnd(){
        //计算有多少个
        let w = self.frame.width / 2
        let count = Int(w / (self.calibrationWidth + space))
        for i in 0...count{
            let x = (self.myScrollView.contentSize.width - w) + CGFloat(i) * (space + self.calibrationWidth)
            if i != 0{
                var height: CGFloat = 0
                if i % self.count == 0{
                    height = self.longHeigh
                }else{
                    height = self.shortHeigh
                }
                let line = UIView(frame: CGRect(x: x, y: 0, width: self.calibrationWidth, height: height))
                line.backgroundColor = UIColor.lightGray
                self.myScrollView.addSubview(line)
            }
        }
    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let w = self.calibrationWidth + space
        let value = (offsetX / w) / CGFloat(self.count)
        let str = String(format: "%.1f", value)
        self.valueHandle?(Float(str)!)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("结束")
        let offsetX = scrollView.contentOffset.x
        self.setEndOffseX(with: offsetX)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print("滑动结束")
        let offsetX = scrollView.contentOffset.x
        self.setEndOffseX(with: offsetX)
    }
   
    fileprivate func setEndOffseX(with offsetX: CGFloat){
        let w = self.calibrationWidth + space
        let value = (offsetX / w) / CGFloat(self.count)
        let str = String(format: "%.1f", value)
        let setOffsetX = CGFloat(Float(str)!) * CGFloat(self.count) * w
        self.myScrollView.contentOffset.x = setOffsetX
        
        self.valueHandle?(Float(str)!)
        
    }
}
