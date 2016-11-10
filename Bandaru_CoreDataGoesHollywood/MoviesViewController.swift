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
    @IBAction func segmentAction(sender: AnyObject) {
        if  sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) == "By Release Date" {
            if let date:Int = Int((releaseDateTF.text)!){
           fetchMovieByReleaseDate(date)
            }
            else{
                displayMessage("Enter a vaild release date(only year)")
            }
        }
        else if sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) == "By Director" {
            let name:[String] = (directorTF.text?.componentsSeparatedByString(", "))!
            if name[0] != "" && name[1] != "" {
           fetchMovieByDirector(name)
            }
            else{
                displayMessage("Enter last name and first name sperated by comma")
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
    
  
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    @IBAction func initializeDB(sender: AnyObject) {
        var hollywoodDreamMaker = HollywoodDreamMaker()
        hollywoodDreamMaker.initializeDB()
        displayMessage("Database has been initialized")
        
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
            
            let fetchRequest = NSFetchRequest(entityName:"Movie")
            let allMovies =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Movie]
            
            movies = []
            
            for movie in allMovies {
                if movie.director != [] {
                if (movie.director as! Director).firstName!.lowercaseString == name[1].lowercaseString && (movie.director as! Director).lastName!.lowercaseString == name[0].lowercaseString {
                    movies.append(movie)
                }
                }
            }
            if movies != [] {
                self.moviesTableView.reloadData()
            }
            else{
                displayMessage("No records")
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
            let allMovies =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Movie]
            movies = []
            
            for movie in allMovies {
                if movie.releaseYear == date {
                    movies.append(movie)
                }
            }
            
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
    
    @IBAction func doneAddingMovies(segue:UIStoryboardSegue){
        
    self.moviesTableView.reloadData()
    

    }
    
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
