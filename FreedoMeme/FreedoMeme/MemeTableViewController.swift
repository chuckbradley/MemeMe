//
//  MemeTableViewController.swift
//  FreedoMeme
//
//  Created by Chuck Bradley on 3/19/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController:UIViewController, UITableViewDataSource {
    
    var memes: [Meme]!

    // load memes before loading view
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
    }

    // after appearing (and animating) check for memes
    // if no memes, display editor
    override func viewDidAppear(animated: Bool) {
        if memes.count == 0 {
            performSegueWithIdentifier("openEditor", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openEditor" {
            // inform editor of memes.count so Cancel button can be enabled or not
            let controller = segue.destinationViewController as MemeEditorViewController
            controller.memesCount = memes.count
        }
    }

    
    /* table handlers */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as UITableViewCell
        let meme = self.memes[indexPath.row]

        // populate image and labels via tag addresses
        if let topTextLabel = cell.viewWithTag(101) as? UILabel {
            topTextLabel.text = meme.topText
        }
        if let bottomTextLabel = cell.viewWithTag(102) as? UILabel {
            bottomTextLabel.text = meme.bottomText
        }
        if let memeImageView = cell.viewWithTag(103) as? UIImageView {
            memeImageView.image = meme.memedImage
        }

        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}

