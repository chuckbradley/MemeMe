//
//  MemeCollectionViewController.swift
//  FreedoMeme
//
//  Created by Chuck Bradley on 3/19/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [Meme]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // load memes before loading view
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes

        // reload data in collection
        collectionView.reloadData()
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
    


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // get cell and populate its image and labels
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as MemeCollectionCellViewController
        let meme = self.memes[indexPath.row]
        cell.setValues(meme)

        return cell
        
    }


    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        // get detail VC and set its meme
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)

    }


}
