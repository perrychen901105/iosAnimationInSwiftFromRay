//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by chenzhipeng on 4/19/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject ,UIViewControllerAnimatedTransitioning {
    let animationDuration = 2.0
    var operation: UINavigationControllerOperation = .Push
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        if operation == .Push {
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
            
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
            
            transitionContext.containerView().addSubview(toVC.view)
            
            let animation = CABasicAnimation(keyPath: "transform")
            
            animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
            
            animation.toValue = NSValue(CATransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0), CATransform3DMakeScale(150.0, 150.0, 1.0)))
            
            animation.duration = animationDuration
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.removedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let fadeinAnimation = CABasicAnimation(keyPath: "opacity")
            fadeinAnimation.fromValue = 0.0
            fadeinAnimation.toValue = 1.0
            fadeinAnimation.duration = animationDuration
//            fadeinAnimation.fillMode = kCAFillModeForwards
//            fadeinAnimation.removedOnCompletion = false
            
            toVC.maskLayer.addAnimation(animation, forKey: nil)
            toVC.view.layer.addAnimation(fadeinAnimation, forKey: nil)
            fromVC.logo.addAnimation(animation, forKey: nil)
        } else {
            let containerView = transitionContext.containerView()
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
//            containerView.addSubview(fromView)
            containerView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseIn, animations: {
                fromView.transform = CGAffineTransformMakeScale(0.01, 0.01)
                }, completion: {_ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
            
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled())
            
            // reset logo
            let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
            fromVC.logo.removeAllAnimations()
            storedContext = nil
        }
    }
}
