//
//  DirectorsViewController.swift
//  Bandaru_CoreDataGoesHollywood
//
//  Created by sreekanth b on 11/5/16.
//  Copyright © 2016 sreekanth bandaru. All rights reserved.
//

import UIKit
import CoreData
class DirectorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let managedObjectContext =  (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    
    @IBOutlet weak var directorsTV: UITableView!
 
    //Stores the fetched director data
    var directors = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        do{
            let fetchRequest = NSFetchRequest(entityName: "Director")
            directors = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Director]
            
            
        }catch{
            print("Error occured when fetching directors: \(error)")
        }
        self.directorsTV.reloadData()
    }
    @IBAction func doneAddingDirector(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func cancelAddingDirector(segue:UIStoryboardSegue){
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return directors.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return (directors[section] as! Director).movies!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier("director_cell", forIndexPath: indexPath)
        let director = (directors[indexPath.section] as! Director)
       let movies = director.movies?.allObjects
        let movie:Movie = movies![indexPath.row] as! Movie
        cell.textLabel?.text  = String(movie.title!)
      

        
        return cell
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (directors[section] as! Director).lastName! + " " + (directors[section] as! Director).firstName!
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
