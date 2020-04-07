//
//  CardPresentationController.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 3/24/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

final class BlurPresentationController: UIPresentationController {

    private lazy var blurView = UIVisualEffectView(effect: nil)
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        if let container = containerView{
            blurView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(blurView)
            blurView.edges(to: container, top: 0, left: 0, bottom: 0, right: 0)
            blurView.alpha = 0.0

            presentingViewController.beginAppearanceTransition(false, animated: false)
            presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (ctx) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.blurView.effect = UIBlurEffect(style: .light)
                    self.blurView.alpha = 1
                })
            }) { (ctx) in }
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (ctx) in
            self.blurView.alpha = 0.0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        if completed {
            blurView.removeFromSuperview()
        }
    }
}
