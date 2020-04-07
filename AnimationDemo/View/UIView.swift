//
//  UIView.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 4/3/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

extension UIView {
    /// Constrain 4 edges of `self` to specified `view`.
    func edges(to view: UIView? = nil, top: CGFloat?, left: CGFloat?, bottom: CGFloat?, right: CGFloat?) {
        
        translatesAutoresizingMaskIntoConstraints = false
        guard let v: UIView = view == nil ? superview : view else {
            return
        }
        
        if let top = top{
            self.topAnchor.constraint(equalTo: v.topAnchor, constant: top).isActive = true
        }
        
        if let left = left{
            self.leftAnchor.constraint(equalTo: v.leftAnchor, constant: left).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: bottom).isActive = true
        }
        
        if let right = right{
            self.rightAnchor.constraint(equalTo: v.rightAnchor, constant: right).isActive = true
        }
    }
    
    func edges(to view: UIView? = nil, top: CGFloat?, leading: CGFloat?, bottom: CGFloat?, trailling: CGFloat?) {
        
        translatesAutoresizingMaskIntoConstraints = false
        guard let v: UIView = view == nil ? superview : view else {
            return
        }
                
        if let top = top{
            self.topAnchor.constraint(equalTo: v.topAnchor, constant: top).isActive = true
        }
        
        if let leading = leading{
            self.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: leading).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: bottom).isActive = true
        }
        
        if let trailling = trailling{
            self.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: trailling).isActive = true
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailling: NSLayoutXAxisAnchor?, padding: UIEdgeInsets, size: CGSize = .zero){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailling = trailling{
            trailingAnchor.constraint(equalTo: trailling, constant: padding.right).isActive = true
        }
        
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension CGRect{
    public mutating func add(safeInset: UIEdgeInsets){
        let newRect = CGRect(x: minX + safeInset.left,
                             y: minY + safeInset.top,
                             width: width - safeInset.left - safeInset.right,
                             height: height - safeInset.top - safeInset.bottom)
        origin = newRect.origin
        size = newRect.size
    }
}
