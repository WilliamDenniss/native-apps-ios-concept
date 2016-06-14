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

  var urlToLoad: URL? = nil;
  
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


  func loadURL(_ urlToLoad: URL)
  {
    webView.loadRequest(URLRequest(url: urlToLoad))
  }

  func webViewDidFinishLoad(_ webView: UIWebView)
  {
    activityIndicator.stopAnimating()
  }

  @IBAction func onDone(_ sender: AnyObject)
  {
    self.presentingViewController!.dismiss(animated: true, completion:nil)
  }

}
