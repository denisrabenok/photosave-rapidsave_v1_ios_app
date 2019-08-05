//
//  addCoinsViewController.swift
//  PhotoSave
//
//  Created by Ritesh Arora on 5/4/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit
import StoreKit
import GoogleMobileAds

struct Constants
{
    static let adUnitId = "ca-app-pub-7278774225545986/8707345797"
}

class addCoinsViewController: UIViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver, GADRewardBasedVideoAdDelegate
{
    var window = UIWindow()
    @IBOutlet var lblOutlet_NumberOfCoins: UILabel!
    @IBOutlet var btnOutlet_GetCoins: UIButton!
    @IBOutlet var btnOutlet_RateUs: UIButton!
    @IBOutlet var btnOutlet_inApp: UIButton!
    
    var product_id: NSString?
    var productsArray: Array<SKProduct?> = []
    var isPending = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        product_id = "com.photosaver888.unlimitedcoins"
        SKPaymentQueue.default().add(self)
        
        // Do any additional setup after loading the view.

        // Configure Admob
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: Constants.adUnitId)
        
        NotificationCenter.default.addObserver(self, selector:#selector(addCoinsViewController.onBecameActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        btnOutlet_GetCoins.layer.cornerRadius = btnOutlet_GetCoins.frame.size.height/2
        btnOutlet_RateUs.layer.cornerRadius = btnOutlet_RateUs.frame.size.height/2
        btnOutlet_inApp.layer.cornerRadius = btnOutlet_GetCoins.frame.size.height/2

        lblOutlet_NumberOfCoins.text = UserDefaults.standard.value(forKey: "points") as? String
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let count : Int = response.products.count
        if (count>0) {
            let validProducts = response.products
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id as? String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(product: validProduct);
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func buyProduct(product: SKProduct) {
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
    }
    
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction])
    {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                UserDefaults.standard.set(true, forKey: "AdsRemoved")
                self.navigationController?.popViewController(animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.restored:
                print("Transaction completed successfully.")
                UserDefaults.standard.set(true, forKey: "AdsRemoved")
                self.navigationController?.popViewController(animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func onBecameActive()
    {
        if GADRewardBasedVideoAd.sharedInstance().isReady == false {
            GADRewardBasedVideoAd.sharedInstance().delegate = self
            GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: Constants.adUnitId)
        }
    }
    
    @IBAction func UnlimitedCoinsButton(_ sender: Any)
    {
        
        let iapAlert = UIAlertController(title: "Purchase", message: "Unlimited Coins", preferredStyle: UIAlertControllerStyle.alert)
        
        iapAlert.addAction(UIAlertAction(title: "Unlimited coins $1.99", style: .default, handler: { (action: UIAlertAction!) in
            self.purchaseUnlimitedCoins()
        }))
        
        iapAlert.addAction(UIAlertAction(title: "Restore purchases", style: .default, handler: { (action: UIAlertAction!) in
            self.restorePurchases()
        }))
        
        iapAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(iapAlert, animated: true, completion: nil)
    }
    
    func purchaseUnlimitedCoins()
    {
        if (SKPaymentQueue.canMakePayments()) {
            let productID:NSSet = NSSet(object: self.product_id!);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
        } else {
            print("can't make purchases");
        }
    }
    
    func restorePurchases()
    {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @IBAction func ShowAdButton(_ sender: Any)
    {
        //  [_ad showWithPresentingViewController:self];
//        self.adColony?.show(withPresenting: self)
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
            isPending = false
        }
        else {
            isPending = true
            view.isUserInteractionEnabled = false
        }
//        //Display our ad to the user
//        if let ad = self.ad {
//            if (!ad.expired) {
//                ad.show(withPresenting: self)
//            }
//        }
                let btn = UIButton()
        
                btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                btn.backgroundColor = UIColor.black
                self.window.addSubview(btn)
                self.window.bringSubview(toFront: btn)
        
        //  self.ad?.setClose(nil)
    }

    @IBAction func btnRateUs(_ sender: Any) {
        rateApp() { success in
            print("RateApp \(success)")
        }

    }
    
    func rateApp(completion: @escaping ((_ success: Bool)->())) {
        
        let appId = "id1239315245"
        
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    @IBAction func BackButtonAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Admob video reward delegate
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        let oldPoints = UserDefaults.standard.value(forKey: "points") as! String
        var intOldPoints = Int(oldPoints)
        intOldPoints = intOldPoints! + 4
        let stringOldPoints = String.init(format: "%d", intOldPoints!)
        UserDefaults.standard.setValue(stringOldPoints, forKey: "points")
        UserDefaults.standard.synchronize()

        self.lblOutlet_NumberOfCoins.text = UserDefaults.standard.value(forKey: "points") as? String
        requestAdmobViedeoReward()
    }
    
    func requestAdmobViedeoReward() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == false {
            GADRewardBasedVideoAd.sharedInstance().delegate = self
            GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                        withAdUnitID: Constants.adUnitId)
        }
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        if (isPending) {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
            isPending = false
            view.isUserInteractionEnabled = true        }
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        requestAdmobViedeoReward()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
        requestAdmobViedeoReward()
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.\(error.localizedDescription)")
        if (isPending == true) {
            let iapAlert = UIAlertController(title: "", message: "Ad is not ready. Please try again after a while.", preferredStyle: UIAlertControllerStyle.alert)
            
            iapAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(iapAlert, animated: true, completion: nil)
            isPending = false
            view.isUserInteractionEnabled = true
        }
        
        requestAdmobViedeoReward()
    }
}
