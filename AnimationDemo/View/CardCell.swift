//
//  ImageCell.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 3/27/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    private var cardContentView: CardContentView
    
    private var disabledHighlightedAnimation = false
    
    public var model: CardModel!{
        didSet{
            cardContentView.model = model
        }
    }
    
   public var animatedDuration: TimeInterval = 0.4
    
   public var highlightScale: CGFloat = 0.96
    
    override init(frame: CGRect) {
        cardContentView = CardContentView()
        
        super.init(frame: frame)
        
        addSubview(cardContentView)
        cardContentView.edges(top: 0, leading: 0, bottom: 0, trailling: 0)
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetTransform() {
        transform = .identity
    }
    
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }
    
    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation {
            return
        }
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        let springWithDamping: CGFloat = 0.8
        
        if isHighlighted {
            UIView.animate(withDuration: animatedDuration, delay: 0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .init(scaleX: self.highlightScale, y: self.highlightScale)
               
            }, completion: completion)
        } else {
            UIView.animate(withDuration: animatedDuration, delay: 0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .identity
               
            }, completion: completion)
        }
    }
}
