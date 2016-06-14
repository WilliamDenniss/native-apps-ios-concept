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
  var urlToLoad: URL? = nil;

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    webView = WKWebView()
    webView.navigationDelegate = self

    self.view.insertSubview(webView, at: 0)
    webView.frame = self.view.frame
    webView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y+50, width: self.view.frame.size.width, height: self.view.frame.size.height)

    if (urlToLoad != nil)
    {
      loadURL(urlToLoad!)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func loadURL(_ _urlToLoad: URL)
  {
    urlToLoad = _urlToLoad
    if (webView != nil)
    {
      webView.load(URLRequest(url: urlToLoad!))
    }
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
  {
    activityIndicator.stopAnimating()
  }

  @IBAction func onDone(_ sender: AnyObject)
  {
    self.presentingViewController!.dismiss(animated: true, completion:nil)
  }

}
