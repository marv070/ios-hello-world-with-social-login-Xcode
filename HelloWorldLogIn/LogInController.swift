//
//  logInController.swift
//  HelloWorldLogIn
//
//  Created by Marvin Laucher on 1/5/18.
//  Copyright © 2018 Marvin Laucher. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class LogInController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var faceBookLogInButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        faceBookLogInButton.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
            
        }
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        Auth.auth().signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            print("User loggin in with google")
            self.performSegue(withIdentifier: "viewHelloWorldViewController", sender: self)
        })
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
            
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (FBSDKAccessToken.current() == nil) {
            print(error!.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("User has signed in with Facebook!")
            self.performSegue(withIdentifier: "viewHelloWorldViewController", sender: self)
        })
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! Auth.auth().signOut()
    }

    
}

