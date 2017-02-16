//
//  CloudkitManager.swift
//  CloudKitTestApp
//
//  Created by Samiksha on 15/02/17.
//  Copyright © 2017 Samiksha. All rights reserved.
//

import Foundation
import CloudKit

class CloudkitManager: NSObject {
    
    static let shared = CloudkitManager()
    
    var container: CKContainer!
    var privateDatabase: CKDatabase!
    var customZone: CKRecordZone!
    
    
    override init() {
        super.init()
    }
    
    func setup() {
        container = CKContainer.default()
        privateDatabase = container.privateCloudDatabase
        customZone = CKRecordZone(zoneName: "AppLicenseZone")
        
        let insertRecord = { [unowned self] in
            self.getICloudId {[unowned self] (icloudId) in
                self.checkRecordIfExists(icloudId!, { (success) in
                    if success {
                        print("Sorry! Your cred already exists!")
                    } else {
                        self.createRecord(icloudId!, completion: { (success) in
                            if success {
                                print("GREAT!!!")
                            } else {
                                print("YOU ARE FAILED TO ADD A RECORD!!!")
                            }
                        })
                    }
                })
            }
        }
        
        if UserDefaults.standard.value(forKey:"ZoneName") == nil {
            createZone({ (success) in
                if success {
                    insertRecord()
                } else {
                    print("failed to create zone!!!")
                }
            })
        } else {
            insertRecord()
        }
    }
    
    func createZone(_ completion: @escaping (_ success: Bool)->()) {
        
        privateDatabase.save(customZone, completionHandler: ({returnRecord, error in
            self.customZone = returnRecord
            if error != nil {
                // Zone creation failed
                OperationQueue.main.addOperation {
                    print("Cloud Error\n\(error?.localizedDescription)")
                    completion(false)
                }
            } else {
                // Zone creation succeeded
                OperationQueue.main.addOperation {
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(self.customZone.zoneID.zoneName, forKey: "ZoneName")
                    userDefaults.synchronize()
                    
                    completion(true)
                }
            }
        }))
    }
    
    func getICloudId(_ completion: @escaping (_ id: String?) -> ()) {
        iCloudUserIDAsync() {
            recordID, error in
            if let userID = recordID?.recordName {
                print("received iCloudID \(userID)")
                completion(userID)
            } else {
                print("Fetched iCloudID was nil")
                completion(nil)
            }
        }
    }
    
    /// gets iCloud record name of logged-in user
    func iCloudUserIDAsync(complete: @escaping ( _ instance: CKRecordID?,  _ error: NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error as NSError?)
            } else {
                print("fetched ID \(recordID?.recordName)")
                complete(recordID, nil)
            }
        }
    }
    
    func createRecord(_ id: String, completion: @escaping (_ success: Bool) -> ()) {
        let licenseRecord = CKRecord(recordType: "License", zoneID: customZone.zoneID)
        
        licenseRecord.setObject(id as CKRecordValue?, forKey: "userId")
        licenseRecord.setObject("HK625BMg" as CKRecordValue?, forKey: "licenseNumber")
        
        privateDatabase.save(licenseRecord, completionHandler: { returnRecord, error in
            if error != nil {
                OperationQueue.main.addOperation {
                    print("Cloud Error\n\(error?.localizedDescription)")
                    completion(false)
                }
            } else {
                OperationQueue.main.addOperation {
                    print("Congratulations! You have unlocked full version.")
                    completion(true)
                }
            }
        })
    }
    
    func getRecords(_ completion: @escaping (_ success: Bool, _ records: [Dictionary<String, String>]?)->()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "License", predicate: predicate)
        
        privateDatabase.perform(query, inZoneWith: customZone.zoneID) {
            records, error in
            if error != nil {
                OperationQueue.main.addOperation {
                    print("\(error?.localizedDescription)")
                }
                completion(false, nil)
            } else {
                var licenseRecords = [Dictionary<String, String>]()
                for record in records! {
                    let userId = record.value(forKey: "userId") as! String
                    let license = record.value(forKey: "licenseNumber") as! String
                    let licenseDict = [userId: license]
                    licenseRecords.append(licenseDict)
                }
                print("FETCHED RESULTS!!!")
                completion(true, licenseRecords)
            }
        }
    }
    
    func checkRecordIfExists(_ id: String, _ completion: @escaping (_ success: Bool) -> ()) {
        self.getRecords { (success, records) in
            if success {
                if (records?.count)! > 0 {
                    for itemDict in records! {
                        if itemDict[id] != nil {
                            print("Record already exists")
                            completion(true)
                        }
                    }
                } else {
                    print("This is a new record")
                    completion(false)
                }
            }
        }
    }
}
















