//
//  ViewController.swift
//  PhotoSave
//
//  Created by Ritesh Arora on 5/1/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit
import MediaPlayer
import MBProgressHUD
import Firebase
import ReplayKit
import HTMLKit
import SwiftyJSON

class ViewController: UIViewController,NSURLConnectionDelegate
{
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var coinButton: UIButton!
    
    var session = Session()
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var hud = MBProgressHUD()
    @IBOutlet var TextField_bgView: UIView!
    let REGEX_NAME = "<script type=\"text/javascript\">window._sharedData =(.*)</script>"


    override func viewDidLoad()
    {
        //
        // Set mixpanel properties
        //
        
        let mixPanelHelper = MixPanelHelper.instance
        mixPanelHelper.setMixPanelProperties()
        
        //
        // Set Desc screen preference
        //
        
        UserDefaults.standard.set(false, forKey: "DescScreen")

        self.navigationController?.isNavigationBarHidden = true

        
//        TextField_bgView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "input.png")!)
        
        TextField_bgView.layer.borderColor = UIColor.init(colorLiteralRed: 228/255.0, green: 126/255.0, blue: 129/255.0, alpha: 1.0).cgColor
        TextField_bgView.layer.borderWidth = 1.0
        
        CheckForAppFirstLaunch()
        

//228126129
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "DescScreen")
        
        if UserDefaults.standard.bool(forKey: "AdsRemoved") {
            self.coinButton.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if (UserDefaults.standard.value(forKey: "instagram") == nil) {
//            self.performSegue(withIdentifier: "ShowInstagramView", sender: nil)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.hud.hide(animated: true)
        })
    }
    
    func CheckForAppFirstLaunch()
    {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            PasteCopiedText()
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.pasteCopiedText(notification:)), name: NSNotification.Name(rawValue: "Paste"), object: nil)

        } else {
            print("First launch, setting UserDefault.")
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.pasteCopiedText(notification:)), name: NSNotification.Name(rawValue: "Paste"), object: nil)
            PasteCopiedText()

//            let tutorialsVC = self.storyboard?.instantiateViewController(withIdentifier: "tutorialsVC") as! tutorialsViewController
//            self.navigationController?.pushViewController(tutorialsVC, animated: false)

            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    func pasteCopiedText(notification: NSNotification)
    {
        PasteCopiedText()
    }
    func PasteCopiedText()
    {
        print("paste text")
        let pb: UIPasteboard = UIPasteboard.general
        if pb.string != nil && (pb.string?.contains("instagram"))! {
            urlTextField.text = pb.string
            GetPhotoOrVideoFromInstagram()

        }
        else{
            urlTextField.text = ""
        }
        
    }
    
    @IBAction func CrossButtonAction(_ sender: Any)
    {
        urlTextField.text  = ""
        urlTextField.resignFirstResponder()
    }
    
    @IBAction func NextButtonAction(_ sender: Any)
    {
//        if(UserDefaults.standard.value(forKey: urlTextField.text!) != nil)
//        {
//            let LinkDescVC = self.storyboard?.instantiateViewController(withIdentifier: "LinkDescVC") as! LinkDescViewController
//            LinkDescVC.responseDict = UserDefaults.standard.value(forKey: "ResposeDict") as! NSDictionary
//            LinkDescVC.imageOrVideoData = (UserDefaults.standard.value(forKey: urlTextField.text!) as! NSData) as Data
//            LinkDescVC.UrlStr = urlTextField.text!
//            self.navigationController?.pushViewController(LinkDescVC, animated: false)
//
//        }
//        else
//        {
            if(urlTextField.text! as String == "")
            {
                let alertController = UIAlertController.init(title: "Error!", message: "Empty link", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                { action -> Void in
                    // Put your code here
                })
                self.present(alertController, animated: true)
            }
            else{
                GetPhotoOrVideoFromInstagram()
            }
//        }
    }
    
    @IBAction func OpenInstagram(_ sender: Any)
    {
        let instagramHooks = "instagram://app"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL)
        {
            UIApplication.shared.openURL(instagramUrl! as URL)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
    @IBAction func CoinsButtonAction(_ sender: Any)
    {
        let addCoinsVC = self.storyboard?.instantiateViewController(withIdentifier: "addCoinsVC") as! addCoinsViewController
        self.navigationController?.pushViewController(addCoinsVC, animated: true)
    }
    
    @IBAction func didPressHelpButton(_ sender: Any) {
        for viewController in navigationController!.viewControllers {
            if viewController is tutorialsViewController {
                navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        
        var viewControllers = [UIViewController]()
        for index in 0 ..< navigationController!.viewControllers.count - 1 {
            viewControllers.append(navigationController!.viewControllers[index])
        }
        let tutorialViewController = storyboard?.instantiateViewController(withIdentifier: "tutorialsVC")
        viewControllers.append(tutorialViewController!)
        navigationController?.setViewControllers(viewControllers, animated: true)
    }

    func GetPhotoOrVideoFromInstagram()
    {
//        urlTextField.text = "https://instagram.com/p/BTgkrR6hxBV/";      //image
//
//       urlTextField.text =  "https://instagram.com/p/BTk2pHFjD0k/"    //video file

        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Downloading"

        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            "postman-token": "dd903bbc-5693-996e-06d4-a9dd8d68e002"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: urlTextField.text!)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
                DispatchQueue.main.async(execute: {
                    self.hud.hide(animated: true)
                })
            } else {
//                DispatchQueue.main.async(execute: {
//                    self.hud.hide(animated: true)
//                })
                do {
                    let htmlString = String(data: data!, encoding: .utf8)
//                    print(htmlString);
                    
                    let searchedRange: NSRange = NSMakeRange(0, (htmlString?.characters.count)!)
                    
                    do{
                        let regex : NSRegularExpression = try NSRegularExpression.init(pattern: self.REGEX_NAME, options: .caseInsensitive)
                        let matches: [AnyObject] = regex.matches(in: htmlString!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: searchedRange)
                        for match in matches {
                            
                            let str : NSString = NSString.init(format: "%@", htmlString!)
                            var matchText: NSString = str.substring(with: match.range) as NSString
//                            print("match: \(matchText)")
                            matchText = matchText.replacingOccurrences(of: "<meta property=\"og:image\" content=\"", with: "") as NSString
                            matchText = matchText.replacingOccurrences(of: "\" />", with: "") as NSString
                            matchText = matchText.replacingOccurrences(of: "\" />", with: "") as NSString
                            matchText = matchText.replacingOccurrences(of: "<script type=\"text/javascript\">window._sharedData = ", with: "") as NSString
                            matchText = matchText.replacingOccurrences(of: ";</script>", with: "") as NSString
//                            print("\(matchText)")
                            
                            let objectData = matchText.data(using: String.Encoding.utf8.rawValue)
//                            var json: [NSObject : AnyObject] = JSONSerialization.JSONObjectWithData(objectData, options: .mutableContainers, error: &error)
                            do{
                                let json : NSDictionary = try JSONSerialization.jsonObject(with: objectData!, options: .mutableContainers) as! NSDictionary
                                print("\(json)")
                                
                                let swiftyJson = JSON.parse(matchText as String)
                                guard let postArray = swiftyJson["entry_data"]["PostPage"].array,
                                    postArray.count > 0,
                                    let firstPost = postArray.first else {
                                        self.hud.hide(animated: true)
                                        return
                                }
                                let owner = firstPost["graphql"]["shortcode_media"]["owner"]
//                                let array : NSArray = (json.value(forKey: "entry_data") as! NSDictionary).value(forKey: "PostPage") as! NSArray
//                                let fullName : String = ((((((((json.value(forKey: "entry_data") as! NSDictionary).value(forKey: "PostPage")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "graphql") as! NSDictionary).value(forKey: "shortcode_media") as! NSDictionary).value(forKey: "owner") as! NSDictionary).value(forKey: "full_name") as! String
                                
                                let userName : String = ((((((((json.value(forKey: "entry_data") as! NSDictionary).value(forKey: "PostPage")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "graphql") as! NSDictionary).value(forKey: "shortcode_media") as! NSDictionary).value(forKey: "owner") as! NSDictionary).value(forKey: "username") as! String
                                let profilePicUrl : String = ((((((((json.value(forKey: "entry_data") as! NSDictionary).value(forKey: "PostPage")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "graphql") as! NSDictionary).value(forKey: "shortcode_media") as! NSDictionary).value(forKey: "owner") as! NSDictionary).value(forKey: "profile_pic_url") as! String
                                let typename : String = ((((((((json.value(forKey: "entry_data") as! NSDictionary).value(forKey: "PostPage")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "graphql") as! NSDictionary).value(forKey: "shortcode_media") as! NSDictionary).value(forKey: "__typename") as? String)!
                                
                                let dataDict = NSMutableDictionary()
                                dataDict.setValue(userName, forKey: "name")
                                dataDict.setValue(profilePicUrl, forKey: "profile_pic")

                                if(typename as String == "GraphVideo")
                                {
                                    //video
                                    let videoUrl : String = ((((((((json.value(forKey: "entry_data") as! NSDictionary).value(forKey: "PostPage")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "graphql") as! NSDictionary).value(forKey: "shortcode_media") as! NSDictionary).value(forKey: "video_url") as? String)!
                                    dataDict.setValue(videoUrl, forKey: "content")
                                    dataDict.setValue("1", forKey: "success")
                                }
                                else{
                                    //Image
                                    let post_image : String = (((((((json.value(forKey: "entry_data") as! NSDictionary).value(forKey: "PostPage")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "graphql") as! NSDictionary).value(forKey: "shortcode_media") as! NSDictionary).value(forKey: "display_url") as! String
                                    dataDict.setValue(post_image, forKey: "content")
                                    dataDict.setValue("1", forKey: "success")
                                }
                                
                                DispatchQueue.main.async {
                                    let LinkDescVC = self.storyboard?.instantiateViewController(withIdentifier: "LinkDescVC") as! LinkDescViewController
                                    LinkDescVC.responseDict = dataDict
                                    LinkDescVC.UrlStr = self.urlTextField.text! as String
                                    
                                    guard let ownerId = owner["id"].string,
                                        ownerId == AppSetting.instance.userId else {
                                        self.hud.hide(animated: true)
                                        let alert = UIAlertController(title: "Error", message: "This image is not yours. You can only download your own images", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return
                                    }
                                    
                                    self.navigationController?.pushViewController(LinkDescVC, animated: true)
                                }
                            }

                            
                    }
                    }
                } catch let error as NSError {
                    print(error)
                    DispatchQueue.main.async(execute: {
                        self.hud.hide(animated: true)
                    })
                }
            }

        });
        dataTask.resume()

    }
}

