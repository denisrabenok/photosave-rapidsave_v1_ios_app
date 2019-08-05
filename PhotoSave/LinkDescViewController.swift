//
//  LinkDescViewController.swift
//  PhotoSave
//
//  Created by Ritesh Arora on 5/3/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit
import MediaPlayer
import GoogleMobileAds
import Firebase
import Mixpanel
import FBSDKCoreKit
import Photos
import SDWebImage

class LinkDescViewController: UIViewController,GADBannerViewDelegate
{
    
    @IBOutlet var view_adMobBanner: GADBannerView!
    var responseDict = NSMutableDictionary()
    var imageOrVideoData = Data()
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var ContentType = NSString()
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var lblOutlet_UserName: UILabel!
    @IBOutlet var lblOutlet_UserImage: UIImageView!
    var UrlStr = String()
    @IBOutlet var indicator: UIActivityIndicatorView!
    var moviePlayer : MPMoviePlayerController?

    
    @IBOutlet var User_imageView: UIImageView!

    override func viewDidLoad()
    {
        UserDefaults.standard.set(true, forKey: "DescScreen")

        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        
        indicator.startAnimating()
        
        GetInstaImageOrVideoFile()
        self.initAdMobBanner()
        super.viewDidLoad()
        
        lblOutlet_UserName.text = responseDict.value(forKey: "name") as! String?
        
        let profile_pic = responseDict.value(forKey: "profile_pic") as! String?
//        [cell.job_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL,[[tempArrImgs objectAtIndex:0] valueForKey:@"attachment"]]]
//            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        userImageView.sd_setImage(with: NSURL(string: profile_pic!) as URL!, placeholderImage:nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "AdsRemoved") {
            self.view_adMobBanner.isHidden = true
        }
    }
    
    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {
        view_adMobBanner.adUnitID = "ca-app-pub-8866161738222281/8826302858"
        view_adMobBanner.rootViewController = self
        view_adMobBanner.delegate = self
        view.addSubview(view_adMobBanner)
        
        let request = GADRequest()
        view_adMobBanner.load(request)
    }
    
    func GetInstaImageOrVideoFile()
    {
        var Content : NSString = responseDict.value(forKey: "content") as! NSString
        if Content.contains("jpg")
        {
//            DispatchQueue.main(qos: .background).async {
                print("IMAGE")
                let urlOfLink: NSURL = NSURL.init(string: Content as String)!
//                let dataOfLink = NSData.init(contentsOf: urlOfLink as URL)
            
            
//                let imageData : NSData = dataOfLink!
//                let image : UIImage = UIImage.init(data: (imageData as NSData) as Data)!
                self.User_imageView.sd_setImage(with: urlOfLink as URL!, placeholderImage:nil)
                self.ContentType = "Image"
            Analytics.logEvent("photos_saved", parameters: ["content_type": "photos_saved" as NSObject,"content_id": 5 as NSObject])
            
            Mixpanel.mainInstance().track(event: "photos_saved",
                                          properties: ["content_type": "photos_saved","content_id": 5])
            
            FBSDKAppEvents.logEvent("photos_saved");

//                UserDefaults.standard.setValue(imageData, forKey: self.UrlStr as String)
//                UserDefaults.standard.setValue(self.responseDict, forKey: "ResposeDict")
//            }
        }
        else if Content.contains("png")
        {
            //            DispatchQueue.main(qos: .background).async {
            print("IMAGE")
            let urlOfLink: NSURL = NSURL.init(string: Content as String)!
            //                let dataOfLink = NSData.init(contentsOf: urlOfLink as URL)
            
            
            //                let imageData : NSData = dataOfLink!
            //                let image : UIImage = UIImage.init(data: (imageData as NSData) as Data)!
            self.User_imageView.sd_setImage(with: urlOfLink as URL!, placeholderImage:nil)
            self.ContentType = "Image"
            Analytics.logEvent("photos_saved", parameters: ["content_type": "photos_saved" as NSObject,"content_id": 5 as NSObject])
            
            Mixpanel.mainInstance().track(event: "photos_saved",
                                          properties: ["content_type": "photos_saved","content_id": 5])
            
            FBSDKAppEvents.logEvent("photos_saved");

            //                UserDefaults.standard.setValue(imageData, forKey: self.UrlStr as String)
            //                UserDefaults.standard.setValue(self.responseDict, forKey: "ResposeDict")
            //            }
        }
        else{
            print("video")
            Content = Content.removingPercentEncoding! as NSString
            
//            let urlOfLink: NSURL = NSURL.init(string: "https://scontent-sin6-2.cdninstagram.com/t50.2886-16/18277653_215594192265273_5909913177260294144_n.mp4" as String)!
            
//            DispatchQueue.global(qos: .background).async {
                // Background Thread
                let urlOfLink: NSURL = NSURL.init(string: Content as String)!
                let imageData = NSData(contentsOf: urlOfLink as URL)
                let paths : NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                let documentsDirectory : NSString = paths.object(at: 0) as! NSString
                let appFile = documentsDirectory.appendingPathComponent("MyFile.mp4")
                imageData?.write(toFile: appFile, atomically: true)
                UserDefaults.standard.setValue(imageData, forKey: self.UrlStr as String)
                UserDefaults.standard.setValue(self.responseDict, forKey: "ResposeDict")
                
                let moveUrl : NSURL = NSURL.fileURL(withPath: appFile) as NSURL
//                self.player = AVPlayer.init(url: moveUrl as URL)
//                self.player.actionAtItemEnd = .none
//                self.player.allowsExternalPlayback = true
//                self.playerLayer = AVPlayerLayer.init(player: self.player)
//                self.playerLayer.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.User_imageView.frame.size.height)
//                self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
//                self.view.layer.addSublayer(self.playerLayer)
//                self.player.play()
//                NotificationCenter.default.addObserver(self, selector: #selector(LinkDescViewController.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                
                self.moviePlayer = MPMoviePlayerController(contentURL: moveUrl as URL!)
                if let player = self.moviePlayer {
                    player.view.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.User_imageView.frame.size.height)
                    player.prepareToPlay()
                    player.scalingMode = .aspectFit
                    self.view.addSubview(player.view)
                }
                self.ContentType = "Video"
            Analytics.logEvent("videos_saved", parameters: ["content_type": "videos_saved" as NSObject,"content_id": 6 as NSObject])
            
            Mixpanel.mainInstance().track(event: "videos_saved",
                                          properties: ["content_type": "videos_saved","content_id": 6])
            
            FBSDKAppEvents.logEvent("videos_saved");

                
//                let asset = AVAsset(url: moveUrl as URL)
//                let imageGenerator = AVAssetImageGenerator(asset: asset)
//                let time = CMTimeMake(1, 1)
//                let imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
//                let thumbnail = UIImage(cgImage:imageRef)
//                self.User_imageView.image = thumbnail

//            }
            self.User_imageView.isHidden = true;
        }
    }
    func playerDidFinishPlaying(note: NSNotification)
    {
        print("Video Finished")
        self.playerLayer.isHidden = true
        playBtn.isHidden = false
    }
    @IBAction func CancelButtonAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func PlayButtonAction(_ sender: Any)
    {
        playBtn.isHidden = true
        self.playerLayer.isHidden = false
        self.player.seek(to: kCMTimeZero)
        self.player.play()
    }
    @IBAction func RepostButtonAction(_ sender: Any)
    {
        if ((UserDefaults.standard.value(forKey: "points") as! String) == "0") && !UserDefaults.standard.bool(forKey: "AdsRemoved") {
            let alertController = UIAlertController.init(title: "Not Enough Coins", message: "You have ran out of coins, do you want to earn some coins?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
            { action -> Void in
                // Put your code here
                let addCoinsVC = self.storyboard?.instantiateViewController(withIdentifier: "addCoinsVC") as! addCoinsViewController
                self.navigationController?.pushViewController(addCoinsVC, animated: true)
            })
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
            { action -> Void in
                // Put your code here
            })
            self.present(alertController, animated: true)
        } else {
            let oldPoints = UserDefaults.standard.value(forKey: "points") as! String
            var intOldPoints = Int(oldPoints)
            intOldPoints = intOldPoints! - 1
            let stringOldPoints = String.init(format: "%d", intOldPoints!)
            UserDefaults.standard.setValue(stringOldPoints, forKey: "points")
            UserDefaults.standard.synchronize()
            if(ContentType == "Image")
            {
                Analytics.logEvent("image_reposts", parameters: ["content_type": "image_reposts" as NSObject,"content_id": 1 as NSObject])
                
                Mixpanel.mainInstance().track(event: "image_reposts",
                                              properties: ["content_type": "image_reposts","content_id": 1])
                
                FBSDKAppEvents.logEvent("image_reposts");
                
                let imageToShare = [User_imageView.image!]
                let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
            }
            else{
                Analytics.logEvent("video_reposts", parameters: ["content_type": "video_reposts" as NSObject,"content_id": 2 as NSObject])
                
                Mixpanel.mainInstance().track(event: "video_reposts",
                                              properties: ["content_type": "video_reposts","content_id": 2])
                
                FBSDKAppEvents.logEvent("video_reposts");
                

                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/MyFile.mp4";
                let videoLink = NSURL(fileURLWithPath: filePath)
                let videoToShare = [videoLink]
                let activityViewController = UIActivityViewController(activityItems: videoToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)

            }
        }
    }
    @IBAction func SaveButtonAction(_ sender: Any)
    {
        if ((UserDefaults.standard.value(forKey: "points") as! String) == "0" && !UserDefaults.standard.bool(forKey: "AdsRemoved")) {
            let alertController = UIAlertController.init(title: "Not Enough Coins", message: "You have ran out of coins, do you want to earn some coins?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
            { action -> Void in
                // Put your code here
                let addCoinsVC = self.storyboard?.instantiateViewController(withIdentifier: "addCoinsVC") as! addCoinsViewController
                self.navigationController?.pushViewController(addCoinsVC, animated: true)
            })
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default)
            { action -> Void in
                // Put your code here
            })
            self.present(alertController, animated: true)
        } else {
            let oldPoints = UserDefaults.standard.value(forKey: "points") as! String
            var intOldPoints = Int(oldPoints)
            intOldPoints = intOldPoints! - 1
            let stringOldPoints = String.init(format: "%d", intOldPoints!)
            UserDefaults.standard.setValue(stringOldPoints, forKey: "points")
            UserDefaults.standard.synchronize()
            if(ContentType == "Image")
            {
                Analytics.logEvent("photos_gallery", parameters: ["content_type": "photos_gallery" as NSObject,"content_id": 3 as NSObject])
                
                Mixpanel.mainInstance().track(event: "photos_gallery",
                                              properties: ["content_type": "photos_gallery","content_id": 3])
                
                FBSDKAppEvents.logEvent("photos_gallery");
                

                UIImageWriteToSavedPhotosAlbum(User_imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            else
            {
                Analytics.logEvent("video_gallery", parameters: ["content_type": "video_gallery" as NSObject,"content_id": 4 as NSObject])
                
                Mixpanel.mainInstance().track(event: "video_gallery",
                                              properties: ["content_type": "video_gallery","content_id": 4])
                
                FBSDKAppEvents.logEvent("video_gallery");

                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/MyFile.mp4";
                DispatchQueue.main.async {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            let ac = UIAlertController(title: "Saved!", message: "Your Video has been saved to your gallery.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated: true)
                        }
                    }
                }
            }
        }
    }
    //MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Saving error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
