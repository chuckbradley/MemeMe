//
//  Meme.swift
//  FreedoMeme
//
//  Created by Chuck Bradley on 3/19/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    var topText:String!
    var bottomText:String!
    var rawImage:UIImage!
    var memedImage:UIImage!
    
    init (topText:String, bottomText:String, rawImage:UIImage, memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.rawImage = rawImage
        self.memedImage = memedImage
    }
}