//
//  Newsfeed.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class Newsfeed: UITableViewController {
    
    let userData = UserDefaults.standard.value(forKey: "userData") as! Dictionary<String, String>
    
    var posts: [Dictionary<String, AnyObject>] = []
    
    let postCellIdentifier = "broadcast"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        server.broadcasts().observe(FEventType.childAdded, with: { (snapshot: FDataSnapshot!) in
            
            var post = snapshot.value as! Dictionary<String, AnyObject>
            // saves the ID to allow comments later
            post["broadcastID"] = snapshot.key
            
            self.posts.append(post)
            self.tableView.reloadData()

        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // section 1: Create new Post
        // section 2: posts
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return 1
        } else {
            return Int(posts.count)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "newPost") as! NewPostCell
            cell.textLabel?.text = "New Broadcast"
            cell.textLabel?.textAlignment = NSTextAlignment.center
            return cell
        }
        return postCellAtIndexPath(indexPath)
    }
    
    func postCellAtIndexPath(_ indexPath:IndexPath) -> Postcell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier) as! Postcell
        setNameForCell(cell, indexPath: indexPath)
        setTextForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setNameForCell(_ cell:Postcell, indexPath:IndexPath) {
        cell.nameButton.setTitle(posts[(posts.count - 1) - (indexPath.item)]["fullName"] as? String, for: UIControlState())
        //
        if posts[(posts.count - 1) - (indexPath.item)]["uid"] != nil {
            cell.posterID = posts[(posts.count - 1) - (indexPath.item)]["uid"] as! String
        }
    }
  
    
    
    func setTextForCell(_ cell:Postcell, indexPath:IndexPath) {
        cell.postText.text = posts[(posts.count - 1) - (indexPath.item)]["text"] as? String
        cell.postText.numberOfLines = 4
        cell.postText.sizeToFit()
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45.0
        } else {
            return heightForCell(posts[(posts.count - 1) - (indexPath.item)]["text"] as! String, font: UIFont.systemFont(ofSize: 17.0), width: self.tableView.bounds.width - 22) + 60
        }
    }
    
    func heightForCell(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 4
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    let viewPostSegueIdentifier = "viewPost"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == viewPostSegueIdentifier {
            if let destination = segue.destination as? ViewPost {
                if let postIndex = tableView.indexPathForSelectedRow?.row {
                    var postedID: String = ""
                    
                    // allows for old posts without uid to be opened
                    if posts[(posts.count-1) - (postIndex)]["uid"] != nil {
                        postedID = posts[(posts.count-1) - (postIndex)]["uid"] as! String
                    }
                    
                    destination.thePost = PostData(
                        broadcastID: posts[(posts.count-1) - (postIndex)]["broadcastID"] as! String,
                        posterID: postedID,
                        posterFullName: posts[(posts.count-1) - (postIndex)]["fullName"] as! String,
                        postText: posts[(posts.count-1) - (postIndex)]["text"] as! String
                    )
                }
            }
        }
    }
    

}
