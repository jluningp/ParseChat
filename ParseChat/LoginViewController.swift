//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Jeanne Luning Prak on 6/21/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(sender: AnyObject) {
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
        PFUser.logInWithUsernameInBackground(username, password: password){ (user: PFUser?, error: NSError?) -> Void in
            if let error =  error {
                print("User login failed")
                print(error.localizedDescription)
                //Display pop-up
                let alertController = UIAlertController(title: "Invalid username", message:
                    "The username and password you have entered do not match", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }else{
                print("User logged in successfully")
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ChatRoom") as! ChatRoomController
                self.presentViewController(vc, animated:true, completion: nil)
            }
        }
    }
    
    @IBAction func signup(sender: AnyObject) {
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameLabel.text
        newUser.email = usernameLabel.text
        newUser.password = passwordLabel.text
        
        // call sign up function on the object
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                //Display pop-up
                let alertController = UIAlertController(title: "Invalid username", message:
                    "The username you have requested is already in use", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ChatRoom") as! ChatRoomController
                self.presentViewController(vc, animated:true, completion: nil)

            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
