// Copyright (c) 2015 Ce Zheng
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var chromeInstallationLabel: UILabel!
    @IBOutlet weak var logView: UITextView!
    @IBOutlet weak var openButton: UIButton!
    @IBAction func open(_ sender: UIButton) {
        let inputURL = URL(string: urlInput.text!)!
        let callbackURL = URL(string: "opcsample://")
        if !OpenInChromeController.sharedInstance.openInChrome(inputURL, callbackURL: callbackURL, createNewTab: true) {
            log("[Failed] Cannot open \(inputURL.absoluteString) in Google Chrome. Will try to open it with system openURL")
            if (UIApplication.shared.openURL(inputURL)) {
                log("[Success] Opened \(inputURL.absoluteString) by system openURL.")
            } else {
                log("[Failed] Cannot open \(inputURL.absoluteString) by system openURL.")
            }
        } else {
            log("[Success] Opened \(inputURL.absoluteString) in Google Chrome.")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        urlInput.delegate = self as UITextFieldDelegate
        detectChromeInstallation();
    }
    
    func detectChromeInstallation() {
        if OpenInChromeController.sharedInstance.isChromeInstalled() {
            chromeInstallationLabel.text = "Google Chrome is installed.";
        } else {
            chromeInstallationLabel.text = "Google Chrome is not installed. http and https urls will be opened in Safari.";
        }
    }
    
    func log(_ text: String) {
        logView.text = logView.text + text + "\n";
        logView.scrollRangeToVisible(NSRange(location: logView.text.characters.count, length: 1))
        NSLog(logView.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

