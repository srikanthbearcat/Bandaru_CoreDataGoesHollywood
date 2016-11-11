//
//  AddMovieViewController.swift
//  Bandaru_CoreDataGoesHollywood
//
//  Created by sreekanth b on 11/5/16.
//  Copyright © 2016 sreekanth bandaru. All rights reserved.
//

import UIKit
import CoreData

class AddMovieViewController: UIViewController {
    let managedObjectContext =  (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var costTF: UITextField!
    @IBOutlet weak var releaseDateTF: UITextField!
    @IBOutlet weak var directorNameTF: UITextField!
    
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
            if titleTF.text! != ""  {
                if Double(costTF.text!) != nil {
                    if UInt(releaseDateTF.text!) != nil {
                        var name:[String] = (directorNameTF.text?.componentsSeparatedByString(", "))!
                        if name.count == 2 {

                        let movie = NSEntityDescription.insertNewObjectForEntityForName("Movie", inManagedObjectContext: managedObjectContext) as! Movie
                        movie.title = titleTF.text!
                        movie.cost = Double(costTF.text!)
                        movie.releaseYear = Int(releaseDateTF.text!)
                        
                        do {
                            
                            let fetchRequest = NSFetchRequest(entityName:"Director")
                            let directors =
                                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Director]
                            
                            
                            for director in directors {
                                
                                if director.lastName == name[0] && director.firstName == name[1] {
                                    movie.director = director
                                }
                                
                            }
                            if movie.director == nil{
                                
                                let newDirector = NSEntityDescription.insertNewObjectForEntityForName("Director", inManagedObjectContext: managedObjectContext) as! Director
                                
                                newDirector.lastName = name[0]
                                newDirector.firstName = name[1]
                                movie.director = newDirector
                                
                            }
                            
                        }catch {
                            
                            print("Error when trying to fetch: \(error)")
                        }
                        
                        do {
                            try managedObjectContext.save()
                            
                        } catch {
                            print("Error when trying to save movie: \(error)")
                        }
                        }
                        else{
                            
                            
                            displayMessage("Enter first name and last name seperated by comma")
                        }
                        
                    }else{
                        displayMessage("Enter a valid release date")
                    }
                }
                else{
                    displayMessage("Enter a valid cost")
                }
            }
            else{
                displayMessage("Enter valid title")
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
