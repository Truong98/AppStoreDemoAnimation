//
//  PresentCardAnimatorUsingUIView.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 4/4/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

class PresentCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let params: Params
    
    struct Params {
        let verticalExpandingStyle: CardVerticalExpandingStyle
        let originalCardFrame: CGRect
        var sourceTransition: SourceTransitionDelegate?
        var destTransition: DestinationTransitionDelegate?
    }
    
    private let animationDuration: TimeInterval
    
    private let animationSpringDamping: CGFloat
    
    init(params: Params) {
        self.params = params
        
        let cardPositionY = params.originalCardFrame.minY
        let distanceToBounce = abs(cardPositionY)
        let extentToBounce = cardPositionY < 0 ? params.originalCardFrame.height : UIScreen.main.bounds.height
        let dampFactorInterval: CGFloat = 0.35
        animationSpringDamping = min(1.0 - dampFactorInterval * (distanceToBounce / extentToBounce), 0.65)
        
        let baselineDuration: TimeInterval = 0.7
        let maxDuration: TimeInterval = baselineDuration + 0.4
        animationDuration = baselineDuration + (maxDuration - baselineDuration) * TimeInterval(distanceToBounce / extentToBounce)
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransitionƯithAutoLayout(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let presentedView = transitionContext.view(forKey: .to)!
        let fromOwnerFrame = params.originalCardFrame
        
        container.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        
        /* Pin top (or center Y) and center X of the card, in animated container view */
        let verticalCardDetailAnchor: NSLayoutConstraint = {
            switch params.verticalExpandingStyle {
            case .fromCenter:
                return presentedView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: fromOwnerFrame.height/2 + fromOwnerFrame.minY - container.bounds.height/2)
            case .fromTop:
                return presentedView.topAnchor.constraint(equalTo: container.topAnchor, constant: fromOwnerFrame.minY)
            }
        }()
        let widthCardDetailConstraint = presentedView.widthAnchor.constraint(equalToConstant: fromOwnerFrame.width)
        let heightCardDetailConstraint = presentedView.heightAnchor.constraint(equalToConstant: fromOwnerFrame.height)
        NSLayoutConstraint.activate([widthCardDetailConstraint,
                                     heightCardDetailConstraint,
                                     verticalCardDetailAnchor,
                                     presentedView.centerXAnchor.constraint(equalTo: container.centerXAnchor),])
        
        params.sourceTransition?.sourceTransitionPresentWillBegin?()
        
        params.destTransition?.presentingDestTransitionWillBegin?()
        
        container.layoutIfNeeded()
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration * 0.6) {
            self.params.destTransition?.presentingDestAnimation?(containnerView: container)
            self.params.sourceTransition?.sourceTransitionPresentingAnimation?(containnerView: container)
            
            widthCardDetailConstraint.constant = container.bounds.width
            heightCardDetailConstraint.constant = container.bounds.height
            
            container.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: 0, options: [], animations: {
            
            verticalCardDetailAnchor.constant = 0
            
            container.layoutIfNeeded()
            
        }) { (finised) in
            
            let success = !transitionContext.transitionWasCancelled
            if success{
                presentedView.removeConstraints([widthCardDetailConstraint, heightCardDetailConstraint])
                presentedView.edges(top: 0, leading: 0, bottom: 0, trailling: 0)
            }else{
                
            }
            
            self.params.destTransition?.presentingDestTransitionDidEnd?(success)
            self.params.sourceTransition?.sourceTransitionPresentDidEnd?(success)
            
            transitionContext.completeTransition(success)
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //return animateTransitionƯithAutoLayout(using: transitionContext)
        
        let container = transitionContext.containerView
        container.removeConstraints(container.constraints)
        container.clipsToBounds = true
        
        let presentedView = transitionContext.view(forKey: .to)!
        presentedView.translatesAutoresizingMaskIntoConstraints = true
        presentedView.frame = params.originalCardFrame
        container.addSubview(presentedView)
        
        params.sourceTransition?.sourceTransitionPresentWillBegin?()
        params.destTransition?.presentingDestTransitionWillBegin?()
        
        container.layoutIfNeeded()
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration * 0.6) {
            self.params.destTransition?.presentingDestAnimation?(containnerView: container)
            self.params.sourceTransition?.sourceTransitionPresentingAnimation?(containnerView: container)
            
            presentedView.frame.size = container.bounds.size
            
            container.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: 0, options: [], animations: {
            
            presentedView.frame.origin = container.bounds.origin
            
            container.layoutIfNeeded()
            
        }) { (finised) in
            
            let success = !transitionContext.transitionWasCancelled
            if success{
                //presentedView.removeConstraints([widthCardDetailConstraint, heightCardDetailConstraint])
                presentedView.edges(top: 0, leading: 0, bottom: 0, trailling: 0)
            }else{
                
            }
            
            self.params.destTransition?.presentingDestTransitionDidEnd?(success)
            self.params.sourceTransition?.sourceTransitionPresentDidEnd?(success)
            
            transitionContext.completeTransition(success)
        }
    }
    
}
