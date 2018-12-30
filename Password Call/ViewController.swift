//
//  ViewController.swift
//  Password Call
//
//  Created by burak on 19.12.2017.
//  Copyright © 2017 Burak Yıldırım. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameText.delegate = self
        passwordText.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // If the user clicks anywhere other than the keyboard, hide the keyboard.
        
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Recognize return key from keybord.
        textField.resignFirstResponder()
        return(true)
    }
    
    @IBAction func signInClicked(_ sender: Any) {
    // Check all username information and if there is a match with the entered username information, send it to "HomeScreenVC" otherwise show a warning about that there is no match.
        if usernameText.text != "" && passwordText.text != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            fetchRequest.predicate = NSPredicate(format: "username = %@", usernameText.text!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in (results as? [NSManagedObject])! {
                        if let usernamee = result.value(forKey: "username") as? String{
                            if let pass = result.value(forKey: "pass") as? String {
                                if usernameText.text == usernamee && passwordText.text == pass {
                                    
                                    UserDefaults.standard.set(usernameText.text, forKey: "login")
                                    UserDefaults.standard.synchronize()
                                    
                                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                    
                                    delegate.rememberLogin()
                                    
                                    
                                } else {
                                    let alert = UIAlertController(title: "Error", message: "No Match!", preferredStyle: UIAlertControllerStyle.alert)
                                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                                    alert.addAction(okButton)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            } catch {
                
                
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please Fill Empty Field!", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

