//
//  tutorialsViewController.swift
//  PhotoSave
//
//  Created by Ritesh Arora on 5/4/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit

fileprivate let GotoMainSegueID = "gotoMainView"
fileprivate let GotoLoginSegueID = "gotoLoginView"

class tutorialsViewController: UIViewController,UIScrollViewDelegate
{
    var ImagesArray = NSMutableArray()
    @IBOutlet var ImagesScroll: UIScrollView!
    @IBOutlet var obj_PageControl: UIPageControl!
    @IBOutlet var btnOutlet_Close: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ImagesArray.add("tutorial 01.png")
        ImagesArray.add("tutorial 02.png")
        ImagesArray.add("tutorial 03.png")
        ImagesArray.add("tutorial 04.png")
        
        self.LoadImagesIntoScrollView()
        btnOutlet_Close.layer.borderColor = UIColor.white.cgColor
        btnOutlet_Close.layer.borderWidth = 1.0
        btnOutlet_Close.layer.cornerRadius = btnOutlet_Close.frame.size.height/2

    }
    
    func LoadImagesIntoScrollView()
    {
        let count = CGFloat(ImagesArray.count)
        
        ImagesScroll.contentSize = CGSize(width:self.view.frame.size.width * count, height:ImagesScroll.frame.size.height)
        self.automaticallyAdjustsScrollViewInsets = false;
        ImagesScroll.isPagingEnabled = true;
        ImagesScroll.delegate=self;
        
        var xPos : CGFloat = 0.0
        
        for imageStr in ImagesArray
        {
            let imageView : UIImageView = UIImageView.init(frame: CGRect(x:xPos, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage.init(named: imageStr as! String)
            ImagesScroll.addSubview(imageView)
            
            xPos += self.view.frame.size.width
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func prepareForUnwindToTutorial(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func didCloseButtonPressed(_ sender: Any) {
        guard AppSetting.instance.userId != nil else {
            performSegue(withIdentifier: GotoLoginSegueID, sender: nil)
            return
        }
        
        performSegue(withIdentifier: GotoMainSegueID, sender: nil)
    }
    
    @IBAction func BackButtonAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnClicked_Close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_PageControl(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.5) {
            let product = sender.currentPage * Int(self.view.frame.size.width)
            self.ImagesScroll.contentOffset.x = CGFloat(product)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/self.view.frame.size.width);
        obj_PageControl.currentPage = index;
    }
    
}
