//
//  HomeScreenVC.swift
//  Password Call
//
//  Created by burak on 20.12.2017.
//  Copyright © 2017 Burak Yıldırım. All rights reserved.
//

import UIKit
import CoreData

class HomeScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chosenusername = String()
    var titleArray = [String]()
    var sortTitleArrray = [String]()
    var selectedTitle = String()
    var repeated = Bool()
    var titlename = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    // Check to member is available if it is, so go the first page.
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        self.chosenusername = delegate.sendAMember()
        getTitle()
        self.tableView.reloadData()
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
    // Delete to the user info from user defaults if user logout button is clicked.
        UserDefaults.standard.removeObject(forKey: "login")
        UserDefaults.standard.synchronize()
        
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! UINavigationController
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
    }
    
    func getTitle() { // When this function is called, fetch the data by user name and show the data of that user.
        titleArray.removeAll(keepingCapacity: false)
        sortTitleArrray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Passes")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "hostusername = %@", chosenusername)
        
        
        do {
            
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                }
            }
            for indexOfArray in 0..<titleArray.count {
                sortTitleArrray.append(titleArray[(titleArray.count - 1) - indexOfArray])
            }
            self.tableView.reloadData()
            
        } catch {
            
        }
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortTitleArrray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sortTitleArrray[indexPath.row]
        return cell
    }
    
    @IBAction func addButton(_ sender: Any) {
        repeated = false
        selectedTitle = ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            
    // If segue identifier is "toAdd", send "chosenUsername","chosenTitle" and "repeated" infos to "AddPageVC".
            let destinationVC = segue.destination as! AddPageVC
            destinationVC.chosenusername = self.chosenusername
            destinationVC.chosenTitle = self.selectedTitle
            destinationVC.repeated = self.repeated
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = self.sortTitleArrray[indexPath.row]
        repeated = true
        performSegue(withIdentifier: "toAdd", sender: nil)
    }


}
