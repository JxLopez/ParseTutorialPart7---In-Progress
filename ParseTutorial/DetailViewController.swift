//
//  DetailViewController.swift
//  ParseTutorial
//
//  Created by Ian Bradbury on 06/02/2015.
//  Copyright (c) 2015 bizzi-body. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {
  
  // Container to store the view table selected object
  var currentObject : PFObject?
  
  // Some text fields
  @IBOutlet weak var nameEnglish: UITextField!
  @IBOutlet weak var nameLocal: UITextField!
  @IBOutlet weak var capital: UITextField!
  @IBOutlet weak var currencyCode: UITextField!
  @IBOutlet weak var flag: PFImageView!
  
  var updateObject : PFObject?
  
  // The save button
  @IBAction func saveButton(sender: AnyObject) {
    
    // Use the sent country object or create a new country PFObject
    if let updateObjectTest = currentObject as PFObject? {
      updateObject = currentObject! as PFObject
    } else {
      updateObject = PFObject(className:"Countries")
    }
    
    // Update the object
    if let updateObject = updateObject {
      
      updateObject["nameEnglish"] = nameEnglish.text
      updateObject["nameLocal"] = nameLocal.text
      updateObject["capital"] = capital.text
      updateObject["currencyCode"] = currencyCode.text
      
      // Create a string of text that is used by search capabilites
      var searchText = (capital.text + " " + nameEnglish.text + " " + nameLocal.text + " " + currencyCode.text).lowercaseString
      updateObject["searchText"] = searchText
      
      // Update the record ACL such that the new record is only visible to the current user
      updateObject.ACL = PFACL(user: PFUser.currentUser()!)
      
      // Save the data back to the server in a background task
      updateObject.save()
    }
    
    // Return to table view
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Unwrap the current object object
    if let object = currentObject {
      if let value = object["nameEnglish"] as? String {
        nameEnglish.text = value
      }
      if let value = object["nameLocal"] as? String {
        nameLocal.text = value
      }
      if let value = object["capital"] as? String {
        capital.text = value
      }
      if let value = object["currencyCode"] as? String {
        currencyCode.text = value
      }
      
      // Display standard question image
      var initialThumbnail = UIImage(named: "question")
      flag.image = initialThumbnail
      
      // Replace question image if an image exists on the parse platform
      if let thumbnail = object["flag"] as? PFFile {
        flag.file = thumbnail
        flag.loadInBackground()
      }
    }
  }
}
