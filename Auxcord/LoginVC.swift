//
//  LoginVC.swift
//  Auxcord
//
//  Created by Nishat Anjum on 4/22/17.
//  Copyright © 2017 Auxcord. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func checkForFirstTime() {
        let ref = FIRDatabase.database().reference(fromURL: "https://dayday-39e15.firebaseio.com/users")
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        ref.queryOrderedByKey().queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value == nil || snapshot.value is NSNull) {
                let usersReference = ref.child(uid)
                
                _ = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start{
                    (connection, result, err) in
                    
                    if ((err) != nil) {
                        print("Error: \(String(describing: err))")
                    } else {
                        print("Fetched user: \(String(describing: result))")
                        
                        let values: [String:AnyObject] = result as! [String : AnyObject]
                        
                        // update our database
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            // if there's an error in saving to our firebase database
                            if err != nil {
                                print(err!)
                                return
                            }
                            // no error
                            print("Save the user successfully into Firebase database")
                        })
                        
                        // Present the onboarding view
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Onboarding") {
                            UIApplication.shared.keyWindow?.rootViewController = viewController
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else {
                return
            }
        })
    }
    
    //Facebook Login
    @IBAction func facebookLogin(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error != nil) {
                print("Failed to login: \(String(describing: error?.localizedDescription))")
                return
            } else if (result?.isCancelled)! {
                print("Login is cancelled")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if (error != nil) {
                    print("Login error: \(String(describing: error?.localizedDescription))")
                    let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    self.checkForFirstTime()
                }
                
                /* Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Onboarding") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    
                    self.dismiss(animated: true, completion: nil)
                } */
                
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
