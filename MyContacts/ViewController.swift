//
//  ViewController.swift
//  MyContacts
//
//  Created by Chuck Konkol on 6/4/16.
//  Copyright © 2016 Rock Valley College. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlet and Action
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var status: UILabel!
    
    @IBAction func btnSave(sender: UIButton) {
    }
    
    @IBAction func btnBack(sender: UIBarButtonItem) {
    }
    
    //1
    
    if (contractdb != nil)
    {
       contactdb.setValue(fullname.text, forKey: "fullname")
       
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

