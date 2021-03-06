//
//  ViewPost.swift
//  Homebase
//
//  Shows a selected post and its comments
//
//  Created by Justin Oroz on 10/14/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class ViewPost: UITableViewController {
    
    var thePost = PostData()
    var comments: [Dictionary<String, String>] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        server.broadcasts().child(byAppendingPath: thePost.broadcastID + "/comments").observe(FEventType.childAdded, with: { (snapshot: FDataSnapshot!) in
            
            var comment = snapshot.value as! Dictionary<String, String>
            // saves the ID to allow comments later
            comment["commentID"] = snapshot.key
            
            self.comments.append(comment)
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 { //post section only has 1
            return 2
        } else {
            return comments.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "thePost", for: indexPath) as! Postcell
                cell.nameButton.setTitle(thePost.posterFullName, for: UIControlState())
                cell.posterID = thePost.posterID
                cell.postText.text = thePost.postText
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "newComment", for: indexPath)
                cell.textLabel?.text = "New Comment"
                return cell
            }

        } else {
            return commentCellAtIndexPath(indexPath)
        }

    }
    
    let commentCellIdentifier = "theComments"
    
    func commentCellAtIndexPath(_ indexPath:IndexPath) -> Postcell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier) as! Postcell
        setNameForCell(cell, indexPath: indexPath)
        setTextForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setNameForCell(_ cell:Postcell, indexPath:IndexPath) {
        cell.nameButton.setTitle(comments[indexPath.item]["fullName"]!, for: UIControlState())
        //
        if comments[indexPath.item]["uid"] != nil {
            cell.posterID = comments[indexPath.item]["uid"]!
        }
    }
    
    
    
    func setTextForCell(_ cell:Postcell, indexPath:IndexPath) {
        cell.postText.text = comments[indexPath.item]["text"]!
        //cell.postText.numberOfLines = 0
        cell.postText.sizeToFit()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return heightForCell(thePost.postText, lines: 0,font: UIFont.systemFont(ofSize: 17.0), width: self.tableView.bounds.width - 22) + 60
            } else {
                return 45.0
            }
        } else {
            let commentText: String = comments[indexPath.item]["text"]!
            return heightForCell(commentText, lines: 0,font: UIFont.systemFont(ofSize: 16.0), width: self.tableView.bounds.width - 22) + 60
        }
    }
    
    func heightForCell(_ text:String, lines: Int ,font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = lines
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if self.tableView.indexPathForSelectedRow?.section == 0
            && self.tableView.indexPathForSelectedRow?.row == 1 {
            let newCommentView = segue.destination as! NewComment
            newCommentView.thePostInfo = thePost            
        }
    }
    

}
