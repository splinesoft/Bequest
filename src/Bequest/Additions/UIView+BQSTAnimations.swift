//
//  UIView+BQSTAnimations.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/12/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit
import pop

extension UIView {

    func BQSTBounce(completion: (() -> ())?) {

        self.layer.pop_removeAllAnimations()

        let bounceAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        bounceAnimation.springBounciness = 12
        bounceAnimation.springSpeed = 12
        bounceAnimation.toValue = NSValue(CGSize: CGSizeMake(1, 1))
        bounceAnimation.velocity = NSValue(CGSize: CGSizeMake(2, 2))

        if completion != nil {
            bounceAnimation.completionBlock = { (animation: POPAnimation!, finished) in
                completion!()
            }
        }

        self.layer.pop_addAnimation(bounceAnimation, forKey: "Bounce")
    }
}
