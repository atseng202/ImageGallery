//
//  GalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Alan Tseng on 2/10/18.
//  Copyright © 2018 Alan Tseng. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var draggedImageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
 
    var galleryImage: UIImage? 
//        didSet {
//            let width = CGFloat(80.0)
//            let aspectRatio = galleryImage!.size.width / galleryImage!.size.height
//
//            imageView.sizeToFit()
//            self.addSubview(imageView)
//        }
    
    
    var imageURL: URL?
}
