//
//  WebViewTestViewController.swift
//  SigninVC
//
//  Created by William Denniss on 6/27/15.
//

import UIKit
import WebKit

class WebViewTestViewController: UIViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: UIWebView!

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var urlToLoad: NSURL? = nil;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if (urlToLoad != nil)
    {
      self.loadURL(urlToLoad!);
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func loadURL(urlToLoad: NSURL)
  {
    webView.loadRequest(NSURLRequest(URL: urlToLoad))
  }

  func webViewDidFinishLoad(webView: UIWebView)
  {
    activityIndicator.stopAnimating()
  }

  @IBAction func onDone(sender: AnyObject)
  {
    self.presentingViewController!.dismissViewControllerAnimated(true, completion:nil)
  }

}
