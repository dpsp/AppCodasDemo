//
//  ViewController.swift
//  Coda
//
//  Created by Joyce Echessa on 1/8/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)!
        self.webView.navigationDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false;
        
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        webView.loadRequest(NSURLRequest(URL:NSURL(string:"http://www.ifeng.com")!))
        
        backButton.enabled = false
        forwardButton.enabled = false
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        let request = NSURLRequest(URL:webView.URL!)
        webView.loadRequest(request)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "loading") {
            backButton.enabled = webView.canGoBack
            forwardButton.enabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

}

