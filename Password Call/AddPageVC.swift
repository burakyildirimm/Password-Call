//
//  AddPageVC.swift
//  Password Call
//
//  Created by burak on 20.12.2017.
//  Copyright © 2017 Burak Yıldırım. All rights reserved.
//

import UIKit
import CoreData

class AddPageVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var chosenusername = String()
    var chosenTitle = String()
    var repeated = Bool()
    var password = String()
    
    @IBOutlet weak var saveButtonClicked: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        titleText.delegate = self
        usernameText.delegate = self
        passText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    // Fill the required filds if the chosenTitle value is available at each opening.
        
        if chosenTitle != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Passes")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "title = %@", chosenTitle)
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "title") as? String {
                            titleText.text = title
                        }
                        if let username = result.value(forKey: "username") as? String {
                            usernameText.text = username
                        }
                        if let pass = result.value(forKey: "pass") as? String {
                            passText.text = pass
                        }
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        } else { // Empty required fields if chosenTitle value is not available.
            titleText.text = ""
            usernameText.text = ""
            passText.text = ""
            saveButton.isHidden = true
            deleteButton.isEnabled = false
        }
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
    
    @IBAction func showClicked(_ sender: Any) {
        
    // If the show button is clicked,create a text alert field for password, fetch the password and compare entered password.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format: "username = %@", chosenusername)
        
        do {
            let results = try context.fetch(fetch)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let pass = result.value(forKey: "pass") as? String {
                        password = pass
                    }
                }
            }
        } catch {
            
        }
    // Create an text alert field here.
        let alertController = UIAlertController(title: "Verification", message: "Please Enter Your Password", preferredStyle: UIAlertControllerStyle.alert)
        let alert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alert) in
            let passwordtext = alertController.textFields![0] as UITextField
            
            if passwordtext.text != "" {
                if passwordtext.text == self.password {
                    self.passText.isSecureTextEntry = false
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "Not match your passwords", preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    errorAlert.addAction(okButton)
                    self.present(errorAlert, animated: true)
                }
            }
        }
        alertController.addAction(alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Your Password"
            textField.textAlignment = .center
            textField.layer.cornerRadius = 5
            textField.isSecureTextEntry = true
            
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func deleteClicked(_ sender: UIBarButtonItem) {
        
    // Ask to the password if delete button is clicked from user. Delete object if entered password is correct otherwise show message about wrong password to user.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetch.returnsObjectsAsFaults = false
        fetch.predicate = NSPredicate(format: "username = %@", chosenusername)
        
        do {
            let results = try context.fetch(fetch)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let pass = result.value(forKey: "pass") as? String {
                        password = pass
                    }
                }
            }
        } catch {
            
        }
        
        let alertController = UIAlertController(title: "Verification", message: "You must verify your password!", preferredStyle: UIAlertControllerStyle.alert)
        let alert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alert) in
            let passwordtext = alertController.textFields![0] as UITextField
            
            if passwordtext.text != "" {
                if passwordtext.text == self.password {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Passes")
                    fetch.returnsObjectsAsFaults = false
                    fetch.predicate = NSPredicate(format: "title = %@", self.chosenTitle)
                    
                    do {
                        let results = try context.fetch(fetch)
                        
                        if results.count > 0 {
                            for result in results as! [NSManagedObject] {
                                context.delete(result)
                            }
                            do {
                                try context.save()
                            } catch {
                                print("error delete save")
                            }
                            self.navigationController?.popViewController(animated: true)
                        }
                    } catch {
                        print("error deleting")
                    }
                } else {
                    let errorAlert = UIAlertController(title: "Wrong", message: "Wrong Password", preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    errorAlert.addAction(okButton)
                    self.present(errorAlert, animated: true)
                }
            }
        }
        alertController.addAction(alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Your Password"
            textField.textAlignment = .center
            textField.layer.cornerRadius = 5
            textField.isSecureTextEntry = true
            
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    

    @IBAction func saveButton(_ sender: Any) {
        
        saveButtonClicked.isEnabled = false
        
    // Check to fix it object. If repeated variable value is "false", create a new object. If repated variable value is "true", you can change the object.
        
        if repeated == false {
            if titleText.text != "" && passText.text != "" {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let addObj = NSEntityDescription.insertNewObject(forEntityName: "Passes", into: context)
                
                addObj.setValue(self.chosenusername, forKey: "hostusername")
                addObj.setValue(self.titleText.text!, forKey: "title")
                addObj.setValue(self.usernameText.text!, forKey: "username")
                addObj.setValue(self.passText.text!, forKey: "pass")
                
                do {
                    try context.save()
                } catch {
                    
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Passes")
            fetch.returnsObjectsAsFaults = false
            fetch.predicate = NSPredicate(format: "title = %@", chosenTitle)
            
            let reAdd = NSEntityDescription.insertNewObject(forEntityName: "Passes", into: context)
            
            do {
                let results = try context.fetch(fetch)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        context.delete(result)
                    }
                }
                
                reAdd.setValue(titleText.text!, forKey: "title")
                reAdd.setValue(usernameText.text!, forKey: "username")
                reAdd.setValue(passText.text!, forKey: "pass")
                reAdd.setValue(self.chosenusername, forKey: "hostusername")
                
                do {
                    try context.save()
                } catch {
                    print("error recheck!")
                }
            } catch {
                print("error object delete")
            }
            
            self.chosenTitle = ""
        // Back to the previous page.
            self.navigationController?.popViewController(animated: true)
            
            
        }
        
    }
    
    

}
