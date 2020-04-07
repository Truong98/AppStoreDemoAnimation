//
//  CardTransition.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 3/24/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit



@objc public protocol DestinationTransitionDelegate{
    // Is called before block animation
    @objc optional func presentingDestTransitionWillBegin()
    
    // Is called in block animation
    @objc optional func presentingDestAnimation(containnerView containner: UIView)
        
    // Is called after block animation
    @objc optional func presentingDestTransitionDidEnd(_ completed: Bool)
    
    // Is called before block animation
    @objc optional func dismissalDestTransitionWillBegin()
    
    // Is called in block animation
    @objc optional func dismissingDestAnimation(containnerView containner: UIView)
    
    // Is called after block animation
    @objc optional func dismissalDestTransitionDidEnd(_ completed: Bool)
}

@objc public protocol SourceTransitionDelegate{
    
    @objc optional func sourceTransitionPresentWillBegin()
    
    @objc optional func sourceTransitionPresentingAnimation(containnerView containner: UIView)
    
    @objc optional func sourceTransitionPresentDidEnd(_ completed: Bool)
    
    @objc optional func sourceTransitionDismissWillBegin(containnerView containner: UIView)
    
    @objc optional func sourceTransitionDismissingAnimation(containnerView containner: UIView)
    
    @objc optional func sourceTransitionDismissDidEnd(_ completed: Bool)
    
    // Note: transition smoother depend on safeInset.origin
    @objc optional func safeInsetWhenSourceTransitionDismissing() -> UIEdgeInsets
}

enum CardVerticalExpandingStyle {
    /// Expanding card pinning at the top of animatingContainerView
    case fromTop

    /// Expanding card pinning at the center of animatingContainerView
    case fromCenter
}

final class CardTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    struct Params {
        let verticalExpandingStyle: CardVerticalExpandingStyle
        let originalCardFrame: CGRect
        let originalCardFrameWithoutTransform: CGRect
        var sourceTransition: SourceTransitionDelegate?
        var destTransition: DestinationTransitionDelegate?     
    }

    let params: Params

    init(params: Params) {
        self.params = params
        super.init()
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let p = PresentCardAnimator.Params.init(verticalExpandingStyle: params.verticalExpandingStyle,
                                                     originalCardFrame: params.originalCardFrame,
                                                     sourceTransition: params.sourceTransition,
                                                     destTransition: params.destTransition)
        return PresentCardAnimator(params: p)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let p = DismissCardAnimator.Params.init(originalCardFrame: params.originalCardFrame,
                                                     originalCardFrameWithoutTransform: params.originalCardFrameWithoutTransform,
                                                     sourceTransition: params.sourceTransition,
                                                     destTransition: params.destTransition)
        return DismissCardAnimator(params: p)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    // IMPORTANT: Must set modalPresentationStyle to `.custom` for this to be used.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BlurPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
