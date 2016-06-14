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
  @IBOutlet weak var appNumber: UILabel!
  @IBOutlet weak var urlField: UITextField!
  @IBOutlet weak var logTextView: UITextView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    urlField.text = kTestDomain
    logTextView.text = ""

    appNumber.text = Bundle.main().objectForInfoDictionaryKey("CFBundleName") as! String!

    logTextView.alwaysBounceVertical = true
    logTextView.textContainer.lineBreakMode = NSLineBreakMode.byCharWrapping
    
    let appIdentifierPrefix: String = Bundle.main().objectForInfoDictionaryKey("AppIdentifierPrefix") as! String
    let bundleIdentifier: String = Bundle.main().objectForInfoDictionaryKey("CFBundleIdentifier") as! String

    logMessage("App Started %@%@", appIdentifierPrefix, bundleIdentifier)
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func userURL() -> URL
  {
    if (urlField.text == "")
    {
      return URL(string: kTestDomain)!
    }
    
    let url = URL(string: urlField.text!)
    if (url == nil)
    {
      UIAlertView(title: "Invalid URL", message: "Could not parse URL", delegate: nil, cancelButtonTitle: "OK").show()
      return URL(string: kTestDomain)!
    }
    return url!
  }
  
  // procesess incoming Universal Links
  func universalLinkReceived(_ url: URL)
  {
    dismiss(animated: true, completion: nil)
    resultColor.backgroundColor = UIColor.green()
    logMessage("Universal link recieved: %@", url.absoluteString!)
  }

  // procesess incoming Universal Links
  func customURIReceived(_ url: URL)
  {
    dismiss(animated: true, completion: nil)
    resultColor.backgroundColor = UIColor.green()
    logMessage("Custom URI recieved: %@", url.absoluteString!)
  }

  // SFSafariViewControllerDelegate
  func safariViewControllerDidFinish(_ controller: SFSafariViewController)
  {
    dismiss(animated: true, completion: nil)
    logMessage("safariViewControllerDidFinish")
  }

  // opens the URL in a SFSafariViewController
  @IBAction func oauth(_ sender: AnyObject)
  {
    urlField.resignFirstResponder()
    
    let barColor = UIColor.blue()
    let tintColor = UIColor.white()
    
    let url = userURL()
    let config = SFSafariViewControllerConfiguration()
    //config.preferredBarTintColor = barColor;
    
    let vc = SFSafariViewController(url: userURL(), configuration:config);
    //vc.view.tintColor = tintColor
    vc.delegate = self
    present(vc, animated: true, completion: nil)
    logMessage("Open SFSafariViewController with %@", url)
  }
  
  // clears the color indicator
  @IBAction func onReset(_ sender: AnyObject)
  {
    resultColor.backgroundColor = UIColor.orange()
  }
  
  // calls openURL on a Universal Link supported by this app
  @IBAction func onOpenURL(_ sender: AnyObject) {
    urlField.resignFirstResponder()
    let url = userURL()
    let result:Bool = UIApplication.shared().openURL(url)
    logMessage("openURL on %@, result %@", url, result ? "true" : "false")
  }
  
  @IBAction func shareLog(_ sender: AnyObject)
  {
    let activityVC = UIActivityViewController(activityItems: [logTextView.text], applicationActivities: nil)
    activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
    self.present(activityVC, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: AnyObject!) {
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
  
  func logMessage(_ format: String, _ args: CVarArg...)
  {
    // output to sys log
    NSLogv(format, getVaList(args))

    // prepend to output log
    let log = NSString(format:format, arguments:getVaList(args))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm:ss"
    logTextView.text = String(format:"%@%@%@: %@", logTextView.text, (logTextView.text != "") ? "\n" : "", dateFormatter.string(from: Date()), log)

    //// scroll
    //let bottom:NSRange = NSMakeRange(logTextView.text.characters.count - 1, 1)
    //logTextView.scrollRangeToVisible(bottom)
    //logTextView.flashScrollIndicators()
  }
  
  /* UITextFieldDelegate methods */
  
  func textFieldShouldReturn(_ _textField: UITextField) -> Bool
  {
    _textField.resignFirstResponder()
    return false
  }

}

