//
//  BQSTProgressButton.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

class BQSTProgressButton: UIControl {
    
    enum BQSTProgressButtonState: Int {
        case Unknown = 0
        case Ready
        case Loading
        case Complete
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.opaque = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var progressState: BQSTProgressButtonState = .Unknown {
        didSet {
            switch self.progressState {
            case .Loading:
                let circleRect = CGRectInset(self.bounds, 6, 6)
                self.circleShapeLayer.strokeColor = UIColor.BQSTRedColor().CGColor
                self.circleShapeLayer.path = UIBezierPath(ovalInRect: circleRect).CGPath
                self.layer.addSublayer(self.circleShapeLayer)
            case .Complete:
                self.circleShapeLayer.strokeColor = UIColor.BQSTGreenColor().CGColor
                self.progressPercentage = 1
            default:
                self.circleShapeLayer.removeFromSuperlayer()
            }
            
            self.setNeedsDisplay()
        }
    }
    
    var progressPercentage: Double = 0 {
        willSet {
            self.circleShapeLayer.removeAllAnimations()
            self.circleShapeAnimation.fromValue = 0
            self.circleShapeAnimation.toValue = newValue
        } didSet {
            self.circleShapeLayer.addAnimation(self.circleShapeAnimation, forKey: "drawCircleAnimation")
        }
    }
    
    var progressColor: UIColor = UIColor.BQSTRedColor()
    
    let circleShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.position = CGPointZero
        
        return layer
    }()
    
    let circleShapeAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        animation.repeatCount = 1
        animation.removedOnCompletion = false
        animation.fromValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return animation
    }()
    
    override var highlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        switch self.progressState {
        case .Ready:
            
            ("Send" as NSString).drawInRect(CGRectInset(rect, 0, 10), withAttributes:
                [NSFontAttributeName: UIFont.BQSTFont(18),
                    NSKernAttributeName: NSNull(),
                    NSForegroundColorAttributeName: self.highlighted ? UIColor.whiteColor() : UIColor.BQSTRedColor()])
            
            break
        case .Loading:
            
            ("X" as NSString).drawInRect(CGRectInset(rect, 8, 6), withAttributes: [NSFontAttributeName: UIFont.BQSTFont(22),
                NSForegroundColorAttributeName: self.highlighted ? UIColor.whiteColor() : UIColor.BQSTRedColor()])
            
            break
        default:
            break;
        }
    }
}
