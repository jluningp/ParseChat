//
//  ChatRoomController.swift
//  ParseChat
//
//  Created by Jeanne Luning Prak on 6/21/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit
import Parse

class ChatRoomController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageEntry: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var postTexts : [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ChatRoomController.loadMessages), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    @IBAction func sendMessage(sender: AnyObject) {
            // Create Parse object PFObject
            let post = PFObject(className: "Message_fbuJuly2016")
        
            let message = messageEntry.text ?? ""
        
            // Add relevant fields to the object
            post["text"] = message
            post["user"] = PFUser.currentUser()
            
            // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if success {
                print("Message sent!")
                self.messageEntry.text = ""
            } else {
                print("Error sending message")
            }
        })
    }
    
    func loadMessages() {
        var query = PFQuery(className: "Message_fbuJuly2016", predicate: nil)
        query.includeKey("user")
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.postTexts = posts
                self.tableView.reloadData()
                // do something with the array of object returned by the call
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! ChatCell
        let user = postTexts![indexPath.row]["user"]
        var myName = "Anonymous"
        if let user = user{
            myName = (user.username?!)!
        }
        cell.messageText.text = postTexts![indexPath.row]["text"] as? String
        cell.usernameLabel.text = myName
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let postTexts = postTexts {
            return postTexts.count
        } else {
            return 0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
