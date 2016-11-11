//
//  HollywoodDreamMaker.swift
//  Bandaru_CoreDataGoesHollywood
//
//  Created by sreekanth b on 11/6/16.
//  Copyright © 2016 sreekanth bandaru. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class HollywoodDreamMaker {
    var directors:[[AnyObject]] = [["Spielberg","Steven",1946,"USA"],
                                   ["Nolan","Christopher",1970,"UK"],
                                   ["Abrams", "J.J.", 1966, "USA"] ]
    
    var movies:[[AnyObject]] = [["Minority Report",102.00, 2015, "Spielberg"],
                                ["Saving Private Ryan", 70.00, 1998, "Spielberg"],
                                ["Bridge of Spies", 40.00, 2015, "Spielberg"],
                                ["Interstellar", 165.00, 2014, "Nolan"],
                                ["Inception", 160.00, 2010, "Nolan"],
                                ["The Dark Knight", 180.00, 2008, "Nolan"],
                                ["Star Trek Into Darkness", 190.00, 2013, "Abrams"],
                                ["Super 8", 45.00, 2011, "Abrams"] ]
    
    func initializeDB(){
        
        let managedObjectContext =  (UIApplication.sharedApplication().delegate as!
            AppDelegate).managedObjectContext
        
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Director")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.executeRequest(batchDeleteRequest)
            
        } catch {
            // Error Handling
            print("Error when trying to deleting previous director records: \(error)")
        }
        
        // Create Fetch Request
        let fetchRequest1 = NSFetchRequest(entityName: "Movie")
        
        // Create Batch Delete Request
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        do {
            try managedObjectContext.executeRequest(batchDeleteRequest1)
            
        } catch {
            // Error Handling
            print("Error when trying to deleting previous movie records: \(error)")
        }
        
        //Initializing directors
        for i in directors {
            
            let director0 = NSEntityDescription.insertNewObjectForEntityForName("Director", inManagedObjectContext: managedObjectContext) as! Director
            
            director0.lastName = i[0] as? String
            director0.firstName = i[1] as? String
            director0.yearOfBirth = i[2] as? NSNumber
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Error when trying to save director: \(error)")
            }
            
        }

        
        //Initializing movies
        for movie in movies{
            var allDirectors:[Director] = []
            do {
                let fetchRequest = NSFetchRequest(entityName:"Director")
                allDirectors = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Director]
                
            } catch {
                print("Error when trying to fetch director: \(error)")
            }
            
            let movie0 = NSEntityDescription.insertNewObjectForEntityForName("Movie", inManagedObjectContext: managedObjectContext) as! Movie
            
            movie0.title = movie[0] as? String
            movie0.cost = movie[1] as? NSNumber
            movie0.releaseYear = movie[2] as? NSNumber
            if movie[3] as! String == "Spielberg" {
                for i in allDirectors {
                    if i.lastName == "Spielberg" {
                        movie0.director = i
                    }
                }
            }
            if movie[3] as! String == "Nolan" {
                for i in allDirectors {
                    if i.lastName == "Nolan" {
                        movie0.director = i
                    }
                }
            }
            if movie[3] as! String == "Abrams" {
                for i in allDirectors {
                    if i.lastName == "Abrams" {
                        movie0.director = i
                    }
                }
            }
            
            do {
                try managedObjectContext.save()
                
            } catch {
                print("Error when trying to save movie: \(error)")
            }
            
            
        }
  
        
    }
    
}