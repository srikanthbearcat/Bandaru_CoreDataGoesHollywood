//
//  MoviesViewController.swift
//  Bandaru_CoreDataGoesHollywood
//
//  Created by sreekanth b on 11/5/16.
//  Copyright © 2016 sreekanth bandaru. All rights reserved.
//

import UIKit
import CoreData
class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let managedObjectContext =  (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    //Stores the fetched movie data
    var movies = [NSManagedObject]()

    @IBOutlet weak var releaseDateTF: UITextField!
    @IBOutlet weak var directorTF: UITextField!

    @IBOutlet weak var moviesTableView: UITableView!
    //Called when segmented control buttons are clicked
    @IBAction func segmentAction(sender: AnyObject) {
        if  sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) == "By Release Date" {
            if let date:Int = Int((releaseDateTF.text)!){
                if date > 0  {
                fetchMovieByReleaseDate(date)
                }
                else{
                    movies = []
                    self.moviesTableView.reloadData()
                    displayMessage("Enter a valid date greater than 0")
                }
            }
            else{
                movies = []
                self.moviesTableView.reloadData()
                displayMessage("Enter a vaild release date(only year)")
            }
        }
        else if sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) == "By Director" {
            let name:[String] = (directorTF.text?.componentsSeparatedByString(", "))!
            if name.count == 2 {
                fetchMovieByDirector(name)
            }
            else{
                movies = []
                self.moviesTableView.reloadData()
                displayMessage("Enter first name and last name seperated by comma")
            }
        }
        else {
            fetchAllMovies()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
//Initialize database
    @IBAction func initializeDB(sender: AnyObject) {
        let hollywoodDreamMaker = HollywoodDreamMaker()
        hollywoodDreamMaker.initializeDB()
        displayMessage("Database has been initialized")
        fetchAllMovies()
        self.moviesTableView.reloadData()
        
    }
    //fetch movies
    func fetchAllMovies(){
        do {
            let fetchRequest = NSFetchRequest(entityName:"Movie")
            
            movies =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Movie]
            

        }catch {
            print("Error when trying to fetch all movies: \(error)")
        }

            self.moviesTableView.reloadData()
 
    }
    
    //fetch movies by  director
    func fetchMovieByDirector(name:[String]){
        do {
            let fetchRequestMovie = NSFetchRequest(entityName:"Movie")
            let fetchRequestDirector = NSFetchRequest(entityName:"Director")
            fetchRequestDirector.predicate = NSPredicate(format: "lastName ==[c] %@", name[0])
            fetchRequestDirector.predicate = NSPredicate(format: "firstName ==[c] %@", name[1])
            let directors =
                try managedObjectContext.executeFetchRequest(fetchRequestDirector) as! [Director]
            
            if directors.count > 0{
                fetchRequestMovie.predicate = NSPredicate(format: "director == %@", directors[0])
                movies = try managedObjectContext.executeFetchRequest(fetchRequestMovie) as! [Movie]
            }
                if movies != [] {
                    self.moviesTableView.reloadData()
                }
                else{
                    displayMessage("No records found")
                    self.moviesTableView.reloadData()
                }
           
            }
            catch {
                
                print("Error when trying to fetch: \(error)")
            }
       
    }
    
    //fetch movies by release date
    func fetchMovieByReleaseDate(date:Int){
        
        do {
            
            let fetchRequest = NSFetchRequest(entityName:"Movie")
            fetchRequest.predicate = NSPredicate(format:"releaseYear == %D", date)
            movies =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Movie]

            
        }
        catch {
            
            print("Error when trying to fetch: \(error)")
        }
        self.moviesTableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier("movie_cell", forIndexPath: indexPath)
        
         cell.textLabel?.text = String((movies[indexPath.row] as! Movie).title!)
        cell.detailTextLabel?.text = "Release Date: " + String((movies[indexPath.row] as! Movie).releaseYear!) + " -- " + "Cost: $" + String((movies[indexPath.row] as! Movie).cost!)
        
     
        
        return cell
    }
    //Unwind segue method
    @IBAction func doneAddingMovies(segue:UIStoryboardSegue){
         fetchAllMovies()
    self.moviesTableView.reloadData()
    

    }
    //Unwind segue method
    @IBAction func cancelAddingMovies(segue:UIStoryboardSegue){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // Pass in a String and it will be displayed in an alert view
    func displayMessage(message:String) {
        let alert = UIAlertController(title: "", message: message,
                                      
                                      preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title:"OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert,animated:true, completion:nil)
    }
    
    
}
