//
//  MemeDetailViewController.swift
//  FreedoMeme
//
//  Created by Chuck Bradley on 3/19/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController:UIViewController {
    
    var meme:Meme!
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memedImageView.image = meme.memedImage
    }
    
}

