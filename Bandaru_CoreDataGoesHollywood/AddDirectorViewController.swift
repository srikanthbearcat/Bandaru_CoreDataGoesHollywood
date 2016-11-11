//
//  AddDirectorMovieController.swift
//  Bandaru_CoreDataGoesHollywood
//
//  Created by sreekanth b on 11/5/16.
//  Copyright © 2016 sreekanth bandaru. All rights reserved.
//

import UIKit
import CoreData
class AddDirectorViewController: UIViewController {
    let managedObjectContext =  (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext

    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (sender as! UIBarButtonItem).title == "Cancel" {
            
            
        }
        else {
            var foundDirector = false
            if lastNameTF.text! != ""  {
                if firstNameTF.text! != ""  {
                    if UInt(dobTF.text!) != nil  {
                        do {
                            
                            let fetchRequest = NSFetchRequest(entityName:"Director")
                            let directors =
                                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Director]
                            
                            for director in directors {
                                
                                if director.lastName?.lowercaseString == lastNameTF.text!.lowercaseString && director.firstName?.lowercaseString == firstNameTF.text?.lowercaseString  {
                                    foundDirector = true
                                }
                                
                            }
                            if foundDirector == false {
                                let director = NSEntityDescription.insertNewObjectForEntityForName("Director", inManagedObjectContext: managedObjectContext) as! Director
                                director.lastName = lastNameTF.text!
                                director.firstName = firstNameTF.text!
                                director.yearOfBirth = Int(dobTF.text!)
                            }
                            
                            
                        }catch {
                            
                            print("Error when trying to fetch: \(error)")
                        }
                        
                        do {
                            try managedObjectContext.save()
                            
                        } catch {
                            print("Error when trying to save movie: \(error)")
                        }
                    }else{
                        displayMessage("Enter a valid date of Birth(Year)")
                    }
                }else{
                    displayMessage("Enter a valid first name")
                }
            }else{
                displayMessage("Enter a valid last name")
            }
            
        }

    }
    // Pass in a String and it will be displayed in an alert view
    func displayMessage(message:String) {
        let alert = UIAlertController(title: "", message: message,
                                      
                                      preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title:"OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert,animated:true, completion:nil)
    }

}
