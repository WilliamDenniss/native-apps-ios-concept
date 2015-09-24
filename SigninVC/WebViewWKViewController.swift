//
//  WebViewWKViewController.swift
//  SigninVC
//
//  Created by William Denniss on 6/27/15.
//

import UIKit
import WebKit

class WebViewWKViewController: UIViewController, WKNavigationDelegate {

  var webView: WKWebView!
  var urlToLoad: NSURL? = nil;

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    webView = WKWebView()
    webView.navigationDelegate = self

    self.view.insertSubview(webView, atIndex: 0)
    webView.frame = self.view.frame
    webView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+50, self.view.frame.size.width, self.view.frame.size.height)

    if (urlToLoad != nil)
    {
      loadURL(urlToLoad!)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func loadURL(_urlToLoad: NSURL)
  {
    urlToLoad = _urlToLoad
    if (webView != nil)
    {
      webView.loadRequest(NSURLRequest(URL: urlToLoad!))
    }
  }

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
  {
    activityIndicator.stopAnimating()
  }

  @IBAction func onDone(sender: AnyObject)
  {
    self.presentingViewController!.dismissViewControllerAnimated(true, completion:nil)
  }

}
