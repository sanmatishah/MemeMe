//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Sanmati Shah on 26/07/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .font : UIFont.systemFont(ofSize: 40, weight: .bold),
        .foregroundColor : UIColor.white,
        .strokeColor : UIColor.black,
        .strokeWidth : NSNumber(value: -4 as Float)
    ]

    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemeTextField(textField: topTextField)
        configureMemeTextField(textField: bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
    
    // MARK: Button Click Handlers
    
    @IBAction func shareClicked() {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                let meme = MemeModel(topText: self.topTextField.text,
                                     bottomText: self.bottomTextField.text,
                                     originalImage: self.imagePickerView.image,
                                     memedImage: memedImage)
                self.resetUI()
            }
        }
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked() {
        resetUI()
    }

    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        let viewController = UIImagePickerController()
        if sender == cameraButton {
            viewController.sourceType = .camera
        } else {
            viewController.sourceType = .photoLibrary
        }
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: UI Helper Methods
    
    func configureMemeTextField(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func updateUI() {
        let isImageSelected = imagePickerView.image != nil
        
        shareButton.isEnabled = isImageSelected
        cancelButton.isEnabled = isImageSelected
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if !isImageSelected {
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
        }
        
        topTextField.isHidden = !isImageSelected
        bottomTextField.isHidden = !isImageSelected
    }
    
    func showToolbars(_ showToolbars: Bool) {
        topToolbar.isHidden = !showToolbars
        bottomToolbar.isHidden = !showToolbars
    }
    
    func resetUI() {
        imagePickerView.image = nil
        updateUI()
    }
    
    func generateMemedImage() -> UIImage {

        showToolbars(false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        showToolbars(true)
        
        return memedImage
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            updateUI()
        }        
        dismiss(animated: true, completion: nil)
    }
        
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topTextField && textField.text == "TOP") || (textField == bottomTextField && textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard Methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

