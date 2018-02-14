//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Alan Tseng on 2/10/18.
//  Copyright © 2018 Alan Tseng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageGalleryCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            galleryCollectionView.dataSource = self
            galleryCollectionView.delegate = self
            galleryCollectionView.dragDelegate = self
            galleryCollectionView.dropDelegate = self
        }
    }
    
    
    var imageGallery = [(URL, CGFloat)]()
    
    private var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Image gallery count: \(imageGallery.count)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("View will appear")
        flowLayout?.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("Image gallery count: \(imageGallery.count)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageGallery.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
    
        // Configure the cell
        if let imageCell = cell as? GalleryCollectionViewCell {
            let url = imageGallery[indexPath.item].0
            let ratio = imageGallery[indexPath.item].1
            
            imageCell.spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageGallery[indexPath.item].0 {
                        imageCell.draggedImageView.image = UIImage(data: imageData)
                        imageCell.spinner.stopAnimating()
                    }
                }
            }
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension ImageGalleryCollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (galleryCollectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell)?.draggedImageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
        
        
    }
}

extension ImageGalleryCollectionViewController: UICollectionViewDropDelegate {
    
    private func fetchImage(with imageURL: URL?, using placeholderContext: UICollectionViewDropPlaceholderContext) {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                let urlContents = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    if let imageData = urlContents {
                        if let imageReceived = UIImage(data: imageData) {
                            let aspectRatio = imageReceived.size.width / imageReceived.size.height
                            placeholderContext.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                                self?.imageGallery.insert((url, aspectRatio), at: insertionIndexPath.item)
                            })
                        }
                    } else {
                        placeholderContext.deletePlaceholder()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // item confirmed to come locally
//                if let imageURL = ((item.dragItem.localObject as? NSURL) as URL?)?.imageURL {
                if let image = item.dragItem.localObject as? UIImage {
                    DispatchQueue.main.async { [weak self] in
                        let aspectRatio = image.size.width / image.size.height
                        let imageURL = self?.imageGallery[sourceIndexPath.item].0
                        collectionView.performBatchUpdates({
                            self?.imageGallery.remove(at: sourceIndexPath.item)
                            self?.imageGallery.insert((imageURL!, aspectRatio), at: destinationIndexPath.item)
                            collectionView.deleteItems(at: [sourceIndexPath])
                            collectionView.insertItems(at: [destinationIndexPath])
                        }, completion: nil)
                    }
//                    DispatchQueue.global(qos: .userInitiated).async {
//                        [weak self] in
//                        let urlContents = try? Data(contentsOf: imageURL)
//                        DispatchQueue.main.async {
//                            if let imageData = urlContents {
//                                if let imageReceived = UIImage(data: imageData) {
//                                    let aspectRatio = imageReceived.size.width / imageReceived.size.height
//                                    collectionView.performBatchUpdates({
//                                        self?.imageGallery.remove(at: sourceIndexPath.item)
//                                        self?.imageGallery.insert((imageURL, aspectRatio), at: destinationIndexPath.item)
//                                        collectionView.deleteItems(at: [sourceIndexPath])
//                                        collectionView.insertItems(at: [destinationIndexPath])
//                                    }, completion: nil)
//                                }
//                            }
//                        }
//
//                    }
                    
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                // dragged item is not local
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { (provider, error) in
                    if let imageURL = ((provider as? NSURL) as URL?)?.imageURL {
                        self.fetchImage(with: imageURL, using: placeholderContext)
                    }
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UIViewController) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy , intent: .insertAtDestinationIndexPath)
    }
}

extension ImageGalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio = imageGallery[indexPath.item].1
        let newHeight = 200 / aspectRatio
        return CGSize(width: 200, height: newHeight)
    }
}















