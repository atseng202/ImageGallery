//
//  GalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Alan Tseng on 2/16/18.
//  Copyright © 2018 Alan Tseng. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var galleryTextField: UITextField! {
        didSet {
            galleryTextField.delegate = self
            galleryTextField.clearsOnBeginEditing = false
            galleryTextField.isUserInteractionEnabled = false
            let doubleTap = UITapGestureRecognizer(target: self, action:
                #selector(self.editImageGalleryLabel(byReactingTo:)))
            doubleTap.numberOfTapsRequired = 2
            self.addGestureRecognizer(doubleTap)
        }
    }
    
    @objc func editImageGalleryLabel(byReactingTo gestureRecognizer: UITapGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            galleryTextField.becomeFirstResponder()
            galleryTextField.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        galleryTextField.isUserInteractionEnabled = false 
        return true
    }

}
