//
//  CardContentView.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 4/3/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

class CardContentView: UIView {
    var model: CardModel?{
        didSet{
            if let model = model{
                imageView.image = model.image
                
                secondaryLabel.text = model.secondary
                
                primaryLabel.text = model.primary
                
                descriptionLabel.text = model.description
            }
        }
    }
    
    var topSafeInset: CGFloat = 0{
        didSet{
            secondaryLabelTopAnchorConstraint?.isActive = false
            
            secondaryLabelTopAnchorConstraint = secondaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding + topSafeInset)
            secondaryLabelTopAnchorConstraint?.isActive = true
            
            layoutIfNeeded()
        }
    }
    
    private let padding: CGFloat = 20
    private var imageView = UIImageView()
    private var primaryLabel = UILabel()
    private var secondaryLabel = UILabel()
    private var descriptionLabel = UILabel()
        
    private var secondaryLabelTopAnchorConstraint: NSLayoutConstraint?
    
    init(){
        super.init(frame: .zero)
        
        layer.masksToBounds = true
        addSubview(imageView)
        addSubview(primaryLabel)
        addSubview(secondaryLabel)
        addSubview(descriptionLabel)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.edges(top: 0, leading: 0, bottom: 0, trailling: 0)
        
        secondaryLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        secondaryLabel.textColor = .lightGray
        secondaryLabelTopAnchorConstraint = secondaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding)
        secondaryLabelTopAnchorConstraint?.isActive = true
        secondaryLabel.edges(top: nil, leading: padding, bottom: nil, trailling: nil)
        secondaryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        
        primaryLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        primaryLabel.textColor = .white
        primaryLabel.numberOfLines = 3
        primaryLabel.edges(to: secondaryLabel, top: 50, leading: 0, bottom: nil, trailling: nil)
        primaryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        
        descriptionLabel.font  = UIFont.systemFont(ofSize: padding, weight: .medium)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 4
        descriptionLabel.edges(top: nil, leading: padding, bottom: -padding, trailling: -padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
