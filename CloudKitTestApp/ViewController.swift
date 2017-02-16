//
//  ViewController.swift
//  CloudKitTestApp
//
//  Created by Samiksha on 14/02/17.
//  Copyright © 2017 Samiksha. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       CloudkitManager.shared.setup()
//        //fetch
//            
//            // Setup a predicate and a query
//            let predicate = NSPredicate(value: true)
//            let query = CKQuery(recordType: "Friends", predicate: predicate)
//            
//            // Execute the query which fetch all records from the private database's custome zone
//            privateDatabase.perform(query, inZoneWith: customZone.zoneID) {
//                records, error in
//                if error != nil {
//                    // The query returned an error, on the main thread, show it in the textView
//                    OperationQueue.main.addOperation {
//                        print("\(error?.localizedDescription)")
//                    }
//                } else {
//                    // The query return one or more records, declare an array variable for holding
//                    // records fetched from the private database's FriendsZone
//                    var names = [String]()
//                    
//                    // Add each record in the names array
//                    for record in records! {
//                        let fName = record.value(forKey: "firstName") as! String
//                        let lName = record.value(forKey: "lastName") as! String
//                        names.append(fName + " " + lName)
//                    }
//                    
//                    // Convert the names array to a string
//                    let stringRepresentation = names.joined(separator: "\n")
//                    
//                    // On the main thread dump content of the stringRepresentation variabl in the textView
//                    OperationQueue.main.addOperation {
//                        print("\(stringRepresentation)")
//                    }
//                }
//            }
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

