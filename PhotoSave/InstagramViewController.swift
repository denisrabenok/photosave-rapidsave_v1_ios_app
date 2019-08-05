//
//  InstagramViewController.swift
//  PhotoSave
//
//  Created by Rauno Järvinen on 04/07/2017.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit


class InstagramViewController: UIViewController
{
    typealias JSONDictionary = [String:Any]
    @IBOutlet weak var instagramButton:UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        instagramButton.layer.cornerRadius = instagramButton.frame.size.height/2
    }
    
    @IBAction func connectToInstagram(_ sender: Any)
    {
        print("connect to instagram")
        //Authenticate with Instagram
        //Save username 
        UserDefaults.standard.setValue("username", forKey: "instagram")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
