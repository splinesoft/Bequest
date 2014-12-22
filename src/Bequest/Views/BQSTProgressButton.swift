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
    }
    
    var progressState: BQSTProgressButtonState = .Unknown {
        willSet {
            self.opaque = false
            self.backgroundColor = UIColor.clearColor()
            self.setNeedsDisplay()
            
            switch newValue {
            case .Loading:
                let circleRect = CGRectInset(self.bounds, 6, 6)
                self.circleShapeLayer.position = CGPointZero
                self.circleShapeLayer.path = UIBezierPath(ovalInRect: circleRect).CGPath
                self.layer.addSublayer(self.circleShapeLayer)
            default:
                self.circleShapeLayer.removeFromSuperlayer()
            }
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
        layer.strokeColor = UIColor.BQSTRedColor().CGColor
        layer.lineWidth = 2
        
        return layer
    }()
    
    let circleShapeAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.removedOnCompletion = false
        animation.fromValue = 0
        
        return animation
    }()
    
    override func drawRect(rect: CGRect) {
        switch self.progressState {
        case .Ready:
            
            ("Send" as NSString).drawInRect(rect, withAttributes: [NSFontAttributeName: UIFont.BQSTMonoFont(18),
                NSForegroundColorAttributeName: UIColor.BQSTRedColor()])
            
            break
        case .Loading:
            
            ("X" as NSString).drawInRect(CGRectInset(rect, 8, 6), withAttributes: [NSFontAttributeName: UIFont.BQSTMonoFont(22),
                NSForegroundColorAttributeName: UIColor.BQSTRedColor()])
            
            break
        default:
            break;
        }
    }
}
