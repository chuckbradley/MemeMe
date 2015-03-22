//
//  MemeCollectionCellViewController.swift
//  FreedoMeme
//
//  Created by Chuck Bradley on 3/19/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionCellViewController: UICollectionViewCell {
    
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func setValues(meme:Meme) {
        topTextLabel.text = meme.topText
        bottomTextLabel.text = meme.bottomText
        imageView.image = meme.memedImage
    }

}
