//
//  GalleryTableViewController.swift
//  ImageGallery
//
//  Created by Alan Tseng on 2/16/18.
//  Copyright © 2018 Alan Tseng. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    
    
    var imageGalleries: [String: [(url: URL?, aspectRatio: CGFloat?)]]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var recentlyDeletedImageGalleries: [String: [(url: URL?, aspectRatio: CGFloat?)]]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return imageGalleries?.keys.count ?? 0
        } else {
            // recently deleted section
            return recentlyDeletedImageGalleries?.keys.count ?? 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)

        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
                if let imageGallery = imageGalleries?[(cell.imageGalleryTitle.text)!] {
                    if let navController = segue.destination as? UINavigationController {
                        if let galleryCollectionVC = navController.visibleViewController as? ImageGalleryCollectionViewController {
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
