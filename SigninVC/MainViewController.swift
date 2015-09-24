//
//  ViewController.swift
//  SigninVC
//
//  Created by William Denniss on 6/26/15.
//

import UIKit
import SafariServices

// replace this with your own test domain
let kTestDomain:String = "https://www.oauth2.pw"

class MainViewController: UIViewController, SFSafariViewControllerDelegate, UITextFieldDelegate {

  @IBOutlet weak var resultColor: UIView!
  var hiddenvc: SFSafariViewController!
  @IBOutlet weak var appNumber: UILabel!
  @IBOutlet weak var urlField: UITextField!
  @IBOutlet weak var logTextView: UITextView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    urlField.text = kTestDomain
    logTextView.text = ""

    appNumber.text = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String!

    logTextView.alwaysBounceVertical = true
    logTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
    
    let appIdentifierPrefix: String = NSBundle.mainBundle().objectForInfoDictionaryKey("AppIdentifierPrefix") as! String
    let bundleIdentifier: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier") as! String

    logMessage("App Started %@%@", appIdentifierPrefix, bundleIdentifier)
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func userURL() -> NSURL
  {
    if (urlField.text == "")
    {
      return NSURL(string: kTestDomain)!
    }
    
    let url = NSURL(string: urlField.text!)
    if (url == nil)
    {
      UIAlertView(title: "Invalid URL", message: "Could not parse URL", delegate: nil, cancelButtonTitle: "OK").show()
      return NSURL(string: kTestDomain)!
    }
    return url!
  }
  
  // procesess incoming Universal Links
  func universalLinkReceived(url: NSURL)
  {
    dismissViewControllerAnimated(true, completion: nil)
    resultColor.backgroundColor = UIColor.greenColor()
    logMessage("Universal link recieved: %@", url.absoluteString)
  }

  // procesess incoming Universal Links
  func customURIReceived(url: NSURL)
  {
    dismissViewControllerAnimated(true, completion: nil)
    resultColor.backgroundColor = UIColor.greenColor()
    logMessage("Custom URI recieved: %@", url.absoluteString)
  }

  // SFSafariViewControllerDelegate
  func safariViewControllerDidFinish(controller: SFSafariViewController)
  {
    dismissViewControllerAnimated(true, completion: nil)
    logMessage("safariViewControllerDidFinish")
  }

  // opens the URL in a SFSafariViewController
  @IBAction func oauth(sender: AnyObject)
  {
    urlField.resignFirstResponder()
    
    let url = userURL()
    let vc = SFSafariViewController(URL: userURL(), entersReaderIfAvailable: false)
    vc.delegate = self
    presentViewController(vc, animated: true, completion: nil)
    logMessage("Open SFSafariViewController with %@", url)
  }
  
  // clears the color indicator
  @IBAction func onReset(sender: AnyObject)
  {
    resultColor.backgroundColor = UIColor.orangeColor()
  }
  
  // calls openURL on a Universal Link supported by this app
  @IBAction func onOpenURL(sender: AnyObject) {
    urlField.resignFirstResponder()
    let url = userURL()
    let result:Bool = UIApplication.sharedApplication().openURL(url)
    logMessage("openURL on %@, result %@", url, result ? "true" : "false")
  }
  
  @IBAction func shareLog(sender: AnyObject)
  {
    let activityVC = UIActivityViewController(activityItems: [logTextView.text], applicationActivities: nil)
    activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
    self.presentViewController(activityVC, animated: true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    urlField.resignFirstResponder()

    let url = userURL()

    if let viewController: WebViewTestViewController = segue.destinationViewController as? WebViewTestViewController {
      viewController.urlToLoad = url
      logMessage("Open UIWebView with %@", url)
    }

    if let viewController: WebViewWKViewController = segue.destinationViewController as? WebViewWKViewController {
      viewController.urlToLoad = url
      logMessage("Open WKWebView with %@", url)
    }

  }
  
  func logMessage(format: String, _ args: CVarArgType...)
  {
    // output to sys log
    NSLogv(format, getVaList(args))

    // prepend to output log
    let log = NSString(format:format, arguments:getVaList(args))
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "hh:mm:ss"
    logTextView.text = String(format:"%@%@%@: %@", logTextView.text, (logTextView.text != "") ? "\n" : "", dateFormatter.stringFromDate(NSDate()), log)

    //// scroll
    //let bottom:NSRange = NSMakeRange(logTextView.text.characters.count - 1, 1)
    //logTextView.scrollRangeToVisible(bottom)
    //logTextView.flashScrollIndicators()
  }
  
  /* UITextFieldDelegate methods */
  
  func textFieldShouldReturn(_textField: UITextField) -> Bool
  {
    _textField.resignFirstResponder()
    return false
  }

}

