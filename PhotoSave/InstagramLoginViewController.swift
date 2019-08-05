//
//  InstagramLoginViewController.swift
//  PhotoSave
//
//  Created by Michael Lee on 7/14/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit

fileprivate let GotoMainSegueID = "gotoMainView"

class InstagramLoginViewController: UIViewController,
                                    InstagramLoginDisplay,
                                    UIWebViewDelegate {

    //
    // Outlets
    //
    
    @IBOutlet var webView: UIWebView!
    
    //
    // Helper variable
    //
    
    var executive: InstagramLoginExecutive?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        executive = InstagramLoginExecutive(self)
        executive?.displayDidLoad()
    }
    
    // MARK: - Segue Preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewConroller = segue.destination as? ViewController {
            viewConroller.session = sender as! Session
        }
    }
    // MARK: - Instagram Login Display
    
    func loadDisplay(_ url: String) {
        webView.loadRequest(URLRequest(url: URL.init(string: url)!))
    }
    
    func gotoMain(session: Session) {
        performSegue(withIdentifier: GotoMainSegueID, sender: session)
    }
    
    // MARK: - UIWebView Delegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("Web View Should Start Load")
        let userName = webView.stringByEvaluatingJavaScript(from: "document.getElementsByName('username')[0].value")
        guard let checkResult = executive?.checkShouldStartRequest(request, userName: userName) else {
            return true
        }
        return checkResult
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Web View Load Failed : \(error.localizedDescription)")
    }
}
