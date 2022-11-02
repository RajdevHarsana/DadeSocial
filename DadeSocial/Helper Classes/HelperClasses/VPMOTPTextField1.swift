//
//  VPMOTPTextField.swift
//  VPMOTPView
//  Version 1.1.0
//
//  Created by Varun P M on 14/12/16.
//  Copyright © 2016 Varun P M. All rights reserved.
//

//  MIT License
//
//  Copyright (c) 2016 Varun P M
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class VPMOTPTextField1: UITextField {
    /// Border color info for field
    var borderColor1: UIColor = UIColor(red: 246/255, green: 138/255, blue: 2/255, alpha: 1)
    
    /// Border width info for field
    var borderWidth1: CGFloat = 1
    
    var shapeLayer1: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initalizeUI1(forFieldType type: VPMOTPView1.DisplayType1) {
        switch type {
        case .circular:
            layer.cornerRadius = bounds.size.width / 2
        case .square:
            layer.cornerRadius = 0
        case .diamond:
            addDiamondMask1()
        case .underlinedBottom:
            addBottomView1()
        }
        
        // Basic UI setup
        if type != .diamond && type != .underlinedBottom {
            layer.borderColor = borderColor1.cgColor
            layer.borderWidth = borderWidth1
        }
        
        autocorrectionType = .no
        textAlignment = .center
    }
    
    // Helper function to create diamond view
    fileprivate func addDiamondMask1() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.size.width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height / 2.0))
        path.addLine(to: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height / 2.0))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
        
        shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path.cgPath
        shapeLayer1.lineWidth = borderWidth1
        shapeLayer1.fillColor = backgroundColor?.cgColor
        shapeLayer1.strokeColor = borderColor1.cgColor
        
        layer.addSublayer(shapeLayer1)
    }
    
    // Helper function to create a underlined bottom view
    fileprivate func addBottomView1() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        path.close()
        
        shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path.cgPath
        shapeLayer1.lineWidth = borderWidth1
        shapeLayer1.fillColor = backgroundColor?.cgColor
        shapeLayer1.strokeColor = borderColor1.cgColor
        
        layer.addSublayer(shapeLayer1)
    }
}
