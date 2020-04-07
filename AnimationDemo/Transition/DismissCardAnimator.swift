//
//  DismissCardAnimator.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 3/24/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

final class DismissCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    struct Params {
        let originalCardFrame: CGRect
        let originalCardFrameWithoutTransform: CGRect
        var sourceTransition: SourceTransitionDelegate?
        var destTransition: DestinationTransitionDelegate?
    }
    
    private let params: Params
    
    init(params: Params) {
        self.params = params
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let safeInset = params.sourceTransition?.safeInsetWhenSourceTransitionDismissing?() ?? UIEdgeInsets.zero
        
        let cardDetailView = transitionContext.view(forKey: .from)!
        cardDetailView.translatesAutoresizingMaskIntoConstraints = true
        
        let container = transitionContext.containerView
        container.removeConstraints(container.constraints)
        container.frame.add(safeInset: safeInset)
        container.clipsToBounds = true
        container.addSubview(cardDetailView)
        
        var newFromCardFrameWithoutTransform = params.originalCardFrameWithoutTransform
        newFromCardFrameWithoutTransform.origin.x -= safeInset.left
        newFromCardFrameWithoutTransform.origin.y -= safeInset.top
        
        params.destTransition?.dismissalDestTransitionWillBegin?()
        params.sourceTransition?.sourceTransitionDismissWillBegin?(containnerView: container)
        
        if safeInset != .zero{
            container.layoutIfNeeded()
        }
                
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: max(duration * 0.4, 0.3)) {
            self.params.destTransition?.dismissingDestAnimation?(containnerView: container)
            self.params.sourceTransition?.sourceTransitionDismissingAnimation?(containnerView: container)
            
            cardDetailView.frame.size = newFromCardFrameWithoutTransform.size
            
            container.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            
            cardDetailView.frame.origin = newFromCardFrameWithoutTransform.origin
            
            container.layoutIfNeeded()
            
        }) { (finished) in
            
            let success = !transitionContext.transitionWasCancelled
            
            if success {
                cardDetailView.removeFromSuperview()
                                          
            } else {
                
                container.removeConstraints(container.constraints)
                
                container.addSubview(cardDetailView)
                cardDetailView.edges(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            self.params.destTransition?.dismissalDestTransitionDidEnd?(success)
            self.params.sourceTransition?.sourceTransitionDismissDidEnd?(success)
            
            transitionContext.completeTransition(success)
        }
    }
}
