//
//  HelpVC.swift
//  BharathTest
//
//  Created by RAKSYS on 26/02/21.
//

import UIKit
import WebKit

class HelpVC: UIViewController {

    @IBOutlet weak var documentWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        documentWebView.navigationDelegate = self
        documentWebView.scrollView.isScrollEnabled = true
        documentWebView.scrollView.bounces = true
        documentWebView.scrollView.delegate = self
        guard let helpPDF = Bundle.main.resourceURL?.appendingPathComponent("Help.pdf") else { return }
        documentWebView.loadFileURL(helpPDF, allowingReadAccessTo: helpPDF)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HelpVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
}
extension HelpVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return nil
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
