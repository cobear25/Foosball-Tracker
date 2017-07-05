//
//  NewPlayerViewController.swift
//  FoosballTracker
//
//  Created by Cody Mace on 2/8/17.
//  Copyright © 2017 codymace. All rights reserved.
//

import UIKit

class NewPlayerViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var createPlayerButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!

    var addToMatch = false

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.layer.cornerRadius = cameraButton.bounds.width / 2
        cameraButton.clipsToBounds = true
        cameraButton.imageView?.contentMode = .scaleAspectFill
        nameTextField.attributedPlaceholder = NSAttributedString(string: nameTextField.placeholder!,
                                                                 attributes: [NSForegroundColorAttributeName: UIColor(white: 121/255.0, alpha: 1)])
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.textFieldEnded(_:)))
        self.view.addGestureRecognizer(tap)

        createPlayerButton.backgroundColor = UIColor.white
        createPlayerButton.setBackgroundImage(UIColor.appBlueDisabled.resizeableImageFromColor(), for: .disabled)
        createPlayerButton.setBackgroundImage(UIColor.appBlue.resizeableImageFromColor(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification){
        if self.view.bounds.height <= 480 {
            UIView.animate(withDuration: 0.3, animations: {
                self.topLabel.transform = CGAffineTransform(translationX: 0, y: -47)
                self.nameTextField.transform = CGAffineTransform(translationX: 0, y: -117)
                self.lineView.transform = CGAffineTransform(translationX: 0, y: -120)
                self.cameraButton.transform = CGAffineTransform(translationX: 0, y: -95)
            })
        } else if self.view.bounds.height <= 568 || UIDevice.current.userInterfaceIdiom == .pad {
            UIView.animate(withDuration: 0.3, animations: {
                self.nameTextField.transform = CGAffineTransform(translationX: 0, y: -90)
                self.lineView.transform = CGAffineTransform(translationX: 0, y: -90)
                self.cameraButton.transform = CGAffineTransform(translationX: 0, y: -40)
            })
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        if self.view.bounds.height <= 480 {
            UIView.animate(withDuration: 0.3, animations: {
                self.topLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.nameTextField.transform = CGAffineTransform(translationX: 0, y: 0)
                self.lineView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.cameraButton.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        } else if self.view.bounds.height <= 568 || UIDevice.current.userInterfaceIdiom == .pad {
            UIView.animate(withDuration: 0.3, animations: {
                self.nameTextField.transform = CGAffineTransform(translationX: 0, y: 0)
                self.lineView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.cameraButton.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createPlayerTapped(_ sender: Any) {
        APIClient.sharedInstance.createPlayer(name: nameTextField.text!) { (done) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func imageButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select a profile image", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Take a photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Choose from library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func textFieldEnded(_ sender: Any) {
        nameTextField.resignFirstResponder()
        if nameTextField.text!.isEmpty {
            createPlayerButton.isEnabled = false
        } else {
            createPlayerButton.isEnabled = true
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        if addToMatch {
            dismiss(animated: true, completion: nil)
        } else {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension NewPlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.cameraButton.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


public enum UIUserInterfaceIdiom : Int {
    case unspecified

    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}
