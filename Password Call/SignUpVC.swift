//
//  SignUpVC.swift
//  Password Call
//
//  Created by burak on 19.12.2017.
//  Copyright © 2017 Burak Yıldırım. All rights reserved.
//

import UIKit
import CoreData

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordAgain: UITextField!
    
    
    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var answerText: UITextField!
    
    var randomm = ""
    var i = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        passwordAgain.delegate = self
        answerText.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getRandom()
        
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
    
    @objc func getRandom() {
    // Create random query numbers
        while (i <= 4) {
            
            let random : String = String(Int(arc4random_uniform(UInt32(10))))
            
            randomm = randomm + random
            
            i += 1
            
            if i == 5 {
                queryLabel.text = "Query : \(randomm)"
            }
            
        }
        
    }
    
    
    @IBAction func SignUpClicked(_ sender: Any) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetch.predicate = NSPredicate(format: "username = %@", usernameText.text!)
        fetch.returnsObjectsAsFaults = false
        
        do {
            let usernameResults = try context.fetch(fetch)
    //  Check all usernames and if there is a match, show a warning about the username, otherwise you can check the entered user information with func.
            if usernameResults.count > 0 {
                let alert = UIAlertController(title: "Error", message: "This username is alredy take", preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                userRegister()
                
            }
        } catch {}
    }
    
    
    func userRegister() {
        
        if emailText.text != "" {
            if usernameText.text != "" {
                if passwordText.text != "" {
                    if passwordAgain.text != "" {
                        if answerText.text != "" {
                            
                            if answerText.text == randomm {
                                
                                if passwordAgain.text == passwordText.text {
                                    
                                    UserDefaults.standard.set(usernameText.text, forKey: "login")
                                    UserDefaults.standard.synchronize()
                                    
                                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                    
                                    delegate.rememberLogin()
                                    
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let context = appDelegate.persistentContainer.viewContext
                                    
                                    let createUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                                    
                                    createUser.setValue(usernameText.text!, forKey: "username")
                                    createUser.setValue(emailText.text!, forKey: "mail")
                                    createUser.setValue(passwordText.text!, forKey: "pass")
                                    
                                    
                                    do {
                                        
                                        try context.save()
                                        print("succes signUp")
                                        
                                    } catch {
                                        print("error")
                                        
                                    }
                                    
                                    
                                    
                                } else {
    // Show alert field If entered passwords is not match.
                                    let alert = UIAlertController(title: "Error", message: "Your password do not match !", preferredStyle: UIAlertControllerStyle.alert)
                                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                                    alert.addAction(okButton)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                
                            } else {
    // If query code is not match, so you can show an alert.
                                let alert = UIAlertController(title: "Error", message: "query do not match !", preferredStyle: UIAlertControllerStyle.alert)
                                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert, animated: true, completion: nil)
                                
                                
                            }
                            
                            
                            
                        } else {
    // Here is empty field alert.
                            let alert = UIAlertController(title: "Error", message: "Please Fill Your Empty Field!", preferredStyle: UIAlertControllerStyle.alert)
                            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    } else {
    // Here is empty field alert.
                        let alert = UIAlertController(title: "Error", message: "Please Fill Your Empty Field!", preferredStyle: UIAlertControllerStyle.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
    // Here is empty field alert.
                    let alert = UIAlertController(title: "Error", message: "Please Fill Your Empty Field!", preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            } else {
    // Here is empty field alert.
                let alert = UIAlertController(title: "Error", message: "Please Fill Your Empty Field!!", preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }
        } else {
    // Here is empty field alert
            let alert = UIAlertController(title: "Error", message: "Please Fill Your Empty Field!", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
    // If segue identifier is "toHome", send the info to "HomeScreednVC" that is.
            let destinationVC = segue.destination as! HomeScreenVC
            destinationVC.chosenusername = usernameText.text!
    }
        
        
        
    }

}
