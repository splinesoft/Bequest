//
//  BQSTProgressButton.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

enum BQSTProgressButtonState: Int {
    case Unknown = 0
    case Ready
    case Loading
    case Complete
}

class BQSTProgressButton: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.opaque = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var progressState: BQSTProgressButtonState = .Unknown {
        willSet {
            self.circleShapeLayer.removeAllAnimations()
            
            switch newValue {
            case .Ready:
                self.circleShapeLayer.removeFromSuperlayer()
                self.circleShapeLayer.strokeStart = 0
                self.circleShapeLayer.strokeEnd = 0
                self.accessibilityLabel = "Send"
            case .Loading:
                self.circleShapeLayer.strokeStart = 0
                self.circleShapeLayer.strokeEnd = 0
                self.circleShapeLayer.strokeColor = self.progressColor.CGColor
                self.circleShapeLayer.path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, 9, 9)).CGPath
                self.layer.addSublayer(self.circleShapeLayer)
                self.accessibilityLabel = "Cancel"
                self.accessibilityHint = "Tap to Cancel"

            case .Complete:
                self.circleShapeLayer.removeAllAnimations()
                self.circleShapeLayer.strokeEnd = 1
                self.circleShapeLayer.strokeColor = UIColor.BQSTGreenColor().CGColor
                self.accessibilityLabel = "Complete"
                
            default:
                break
            }
            
            self.layer.setNeedsDisplay()
        }
    }
    
    var progressPercentage: Float = 0 {
        willSet {
            self.circleShapeLayer.removeAllAnimations()
        } didSet {
            UIView.animateWithDuration(0.05,
                delay: 0.0,
                options: .CurveLinear,
                animations: {
                    self.circleShapeLayer.strokeEnd = CGFloat(self.progressPercentage)
                }, completion: nil)
        }
    }
    
    var progressColor: UIColor = UIColor.BQSTRedColor()
    
    private let circleShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.position = CGPointZero
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineCap = kCALineCapRound
        layer.strokeStart = CGFloat(0)
        
        return layer
    }()
    
    override var highlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        switch self.progressState {
        case .Ready:
            
            (BQSTLocalizedString("SEND_REQUEST") as NSString).drawInRect(CGRectInset(rect, 0, 10), withAttributes:
                [NSFontAttributeName: UIFont.BQSTFont(18),
                    NSKernAttributeName: NSNull(),
                    NSForegroundColorAttributeName: self.highlighted ? UIColor.whiteColor() : UIColor.BQSTRedColor()])
            
            break
        case .Loading:
            
            let xRect = CGRectInset(rect, 15, 15)
            
            let context = UIGraphicsGetCurrentContext()
            
            CGContextMoveToPoint(context, CGRectGetMinX(xRect), CGRectGetMinY(xRect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(xRect), CGRectGetMaxY(xRect))
            CGContextMoveToPoint(context, CGRectGetMinX(xRect), CGRectGetMaxY(xRect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(xRect), CGRectGetMinY(xRect))
            CGContextClosePath(context)
            
            CGContextSetLineWidth(context, 3)
            CGContextSetStrokeColorWithColor(context, (self.highlighted ? UIColor.whiteColor().CGColor : UIColor.BQSTRedColor().CGColor))
            
            CGContextStrokePath(context)
            
        default:
            break;
        }
    }
}
