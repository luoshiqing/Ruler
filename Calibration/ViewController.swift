//
//  ViewController.swift
//  Calibration
//
//  Created by lsq on 2017/11/8.
//  Copyright © 2017年 罗石清. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    
    fileprivate var label: UILabel?
    @IBOutlet weak var textField: UITextField!
    
    var calibration: CalibrationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        
        label = UILabel(frame: CGRect(x: 0, y: 150, width: 200, height: 20))
        label?.center.x = self.view.center.x
        label?.textAlignment = .center
        label?.text = "0"
        self.view.addSubview(label!)
        
        let rect = CGRect(x: 15, y: 200, width: self.view.frame.width - 30, height: 50)
        calibration = CalibrationView(frame: rect)
        calibration?.calibrationWidth = 1
        calibration?.max = 20
        calibration?.valueHandle = { [weak self](value) in
            self?.label?.text = "\(value)"
            self?.textField.text = "\(value)"
        }
        //调用此方法开始
        calibration?.show(value: 4.55, animation: true)
        
        self.view.addSubview(calibration!)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text!
        
        if let textV = Float(text){
            self.calibration?.showValue = CGFloat(textV)
        }else{
            self.calibration?.showValue = 0
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

