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
           fetchMovieByReleaseDate()
        }
        else if sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) == "By Director" {
           fetchMovieByDirector()
            
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
        
//        dispatch_async(dispatch_get_main_queue(), { self.moviesTableView.reloadData() })
//        debugPrint(movies.count)
    }
    
    //fetch movies
    func fetchAllMovies(){
        do {
            let fetchRequest = NSFetchRequest(entityName:"Movie")
            movies =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Movie]
            
//            print(movies)
        }catch {
            print("Error when trying to fetch all movies: \(error)")
        }

            self.moviesTableView.reloadData()
 
    }

    //fetch movies by  director
    func fetchMovieByDirector(){
        var name:[String] = (directorTF.text?.componentsSeparatedByString(", "))!
        do {
            
            let fetchRequest = NSFetchRequest(entityName:"Movie")
            let allMovies =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Movie]
            movies = []
            for movie in allMovies {
                if (movie.director as! Director).firstName == name[1] && (movie.director as! Director).lastName == name[0] {
                    movies.append(movie)
                }
            }
        
            }
            catch {
                
                print("Error when trying to fetch: \(error)")
            }
        self.moviesTableView.reloadData()
    }
    
    //fetch movies by release date
    func fetchMovieByReleaseDate(){
        
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

}
