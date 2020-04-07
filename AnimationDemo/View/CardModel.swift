//
//  CardModel.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 4/3/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

class CardModel {
    let primary: String
    let secondary: String
    let description: String
    let image: UIImage
    
    init(primary: String, secondary: String, description: String, image: UIImage) {
        self.primary = primary
        self.secondary = secondary
        self.description = description
        self.image = image
    }
}
