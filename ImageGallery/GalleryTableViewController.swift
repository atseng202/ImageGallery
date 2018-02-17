//
//  GalleryTableViewController.swift
//  ImageGallery
//
//  Created by Alan Tseng on 2/16/18.
//  Copyright © 2018 Alan Tseng. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    
    // MARK: - Internal Gallery Data Structures
    var imageGalleries: [ [ String: [(url: URL?, aspectRatio: CGFloat?)] ] ]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var recentlyDeletedImageGalleries: [ [String: [(url: URL?, aspectRatio: CGFloat?)] ] ]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if imageGalleries == nil {
            imageGalleries = [ [String: [(url: URL?, aspectRatio: CGFloat?)]] ]()
        }
        if recentlyDeletedImageGalleries == nil {
            recentlyDeletedImageGalleries = [[String: [(url: URL?, aspectRatio: CGFloat?)] ] ]()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: - Do something here to update imageGalleries from collectionView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
        if imageGalleries != nil {
            var newGallery: [(URL?, CGFloat?)] = [(url: URL?, aspectRatio: CGFloat?)]()
            imageGalleries?.append(["Untitled": newGallery])
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            // regular section
            return imageGalleries?.count ?? 0
        } else {
            // recently deleted section
            return recentlyDeletedImageGalleries?.count ?? 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)

        // Configure the cell...
        if let galleryCell = cell as? GalleryTableViewCell {
            if indexPath.section == 0, imageGalleries != nil {
                let galleryKeys = imageGalleries![indexPath.row].keys
                for galleryTitle in galleryKeys {
                    galleryCell.imageGalleryTitle?.text = galleryTitle
                }
            } else if indexPath.section == 1, recentlyDeletedImageGalleries != nil {
                let galleryKeys = recentlyDeletedImageGalleries![indexPath.row].keys
                for title in galleryKeys {
                    galleryCell.imageGalleryTitle?.text = title
                }
            }
            
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        }
        return nil
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0, imageGalleries != nil {
                let recentlyDeletedGallery = imageGalleries![indexPath.row]
                let destinationIndexPath = IndexPath(row: 0, section: 1)
                tableView.performBatchUpdates({
                    imageGalleries?.remove(at: indexPath.row)
                    recentlyDeletedImageGalleries?.insert(recentlyDeletedGallery, at: destinationIndexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    
                }, completion: nil) 
            } else if indexPath.section == 1, recentlyDeletedImageGalleries != nil {
//                let toBeDeletedGallery = recentlyDeletedImageGalleries![indexPath.row]
                tableView.performBatchUpdates({
                    recentlyDeletedImageGalleries!.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }, completion: nil)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    private func setUpUndeleteAction(for indexPath: IndexPath) -> UIContextualAction {
        let undeleteAction = UIContextualAction(style: .normal, title: "Undelete", handler: {
            (action, view, completionHandler) in
            if self.recentlyDeletedImageGalleries != nil {
                let restoredGallery = self.recentlyDeletedImageGalleries![indexPath.row]
                let destinationIndexPath = IndexPath(row: 0, section: 0)
                self.tableView.performBatchUpdates({
                    self.recentlyDeletedImageGalleries!.remove(at: indexPath.row)
                    self.imageGalleries?.insert(restoredGallery, at: destinationIndexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                }, completion: nil)
                
            }
        })
        return undeleteAction
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undeleteAction = setUpUndeleteAction(for: indexPath)
            let configuration = UISwipeActionsConfiguration(actions: [undeleteAction])
            return configuration
        } else {
            return nil
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? GalleryTableViewCell, let indexPath = tableView.indexPath(for: cell) {
            switch segue.identifier {
            case "showImageGallery"?:
                if indexPath.section == 0, imageGalleries != nil  {
                    if let imageGallery = imageGalleries![indexPath.row][cell.imageGalleryTitle.text!] {
                        if let galleryCollectionVC = segue.destination.contentsOfController as? ImageGalleryCollectionViewController {
                            galleryCollectionVC.imageGallery = imageGallery
                            galleryCollectionVC.title = cell.imageGalleryTitle.text
                        }
                    }
                }
            default:
                print("Unable to identify segue identifier")
                break
            }
        }
        
        
    }


}

extension UIViewController {
    var contentsOfController: UIViewController {
        if let navController = self as? UINavigationController {
            return navController.visibleViewController ?? navController
        } else {
            return self
        }
    }
}
