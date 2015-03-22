//
//  MemeEditorViewController.swift
//  FreedoMeme
//
//  Created by Chuck Bradley on 3/19/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var instructionLabel: UILabel!

    // local storage
    var topText:String = ""
    var bottomText:String = ""
    var selectedImage:UIImage!
    var memedImage:UIImage!
    
    var meme:Meme!
    var memesCount = 0
    
    // text attributes
    let memeTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.5
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign static properties
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self
        bottomTextField.delegate = self
        // set default states:
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.hidden = true
        bottomTextField.hidden = true
        shareButton.enabled = false
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cancelButton.enabled  = memesCount > 0 ? true : false
    }
    
    

    // hide status bar to give full view to editing
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    
    
    /* image selection */
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    // image picker handling
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let theImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImage = theImage
            imagePickerView.image = theImage
            enableEditing()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    

    /* text editing */
    
    func enableEditing() {
        instructionLabel.hidden = true
        topTextField.hidden = false
        bottomTextField.hidden = false
    }

    
    // on begin editing, if corresponding text storage is empty, clear placeholder text in field
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case self.topTextField :
            if countElements(self.topText) == 0 { textField.text = "" }
        case self.bottomTextField :
            if countElements(self.bottomText) == 0 { textField.text = "" }
        default : println("error: textField switch failed")
        }
    }

    // reset to detault text if empty or enable sharing. 
    // Note: a space will allow for illusion of empty
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.topTextField && countElements(self.topText) == 0 {
            textField.text = "TOP"
        } else if textField == self.bottomTextField && countElements(self.bottomText) == 0 {
            textField.text = "BOTTOM"
        }
        if countElements(self.topText) > 0 && countElements(self.bottomText) > 0 { enableSharing(true) }
    }

    
    // update displayed string in text field and
    // update locally stored values
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // calculate new string
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        // set storage variable with updated new string
        switch textField {
        case self.topTextField : self.topText = newString
        case self.bottomTextField : self.bottomText = newString
        default : return false
        }
        
        return true
    }
    
    // allow return to remove focus (and hide keyboard)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    /* keyboard avoidance */
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    // shift view so keyboard doesn't cover bottom text field
    func keyboardWillShow(notification: NSNotification) {
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification) - 45
        }
    }
    
    // insure that frame is at original position
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    
    /* navigtion */
    
    // dismiss editor (modal)
    @IBAction func cancelMeme(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    /* sharing */
    
    func enableSharing (enable: Bool) {
        shareButton.enabled = enable
    }

    // share meme
    @IBAction func shareMeme(sender: AnyObject) {
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [self.memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            if ok { self.saveMeme() }
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    /* generate & save meme */
    
    func saveMeme() {
        // create a Meme instance with the current values
        meme = Meme(topText: self.topText, bottomText: self.bottomText, rawImage: self.selectedImage, memedImage: self.memedImage)
        // add meme to app list
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        appDelegate.memes.append(meme)

        // close the editor
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        toolBar.hidden = true
        navBar.hidden = true
        
        // Render view to an image (copied from Udacity)
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    

}

