//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by chenzhipeng on 4/17/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 5.0
    var presenting = true
    var originFrame = CGRect.zeroRect
    var dismissCompletion: (()->())?
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
//        containerView.addSubview(toView)
//        toView.alpha = 0.0
//        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            toView.alpha = 1.0
//        }) { _ in
//            transitionContext.completeTransition(true)
//        }
        let herbView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        let herbController = transitionContext.viewControllerForKey(
            presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey
            ) as! HerbDetailsViewController
        
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: CGRectGetMidX(initialFrame), y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            herbController.containerView.alpha = 0.0
        }
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(herbView)
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: nil, animations: { () -> Void in
            herbView.transform = self.presenting ? CGAffineTransformIdentity : scaleTransform
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            herbController.containerView.alpha = self.presenting ? 1.0 : 0.0
        }) { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }
    }
}
