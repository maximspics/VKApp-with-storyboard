//
//  VKLoginController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 03.12.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import WebKit

class VKLoginController: UIViewController {
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = loadComponents()
        webView.load(request)
    }
    
    @IBAction func logOutButtonClicked(segue: UIStoryboardSegue) {
        webView.isHidden = false
        self.deleteAllCookies()
        self.webView.reload()
        let request = loadComponents()
        webView.load(request)
    }
    
    func deleteAllCookies() {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookie in
            cookie.forEach { self?.webView.configuration.websiteDataStore.httpCookieStore.delete($0) }
        }
    }
    
    func loadComponents() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7539955"),
            URLQueryItem(name: "scope", value: "wall,photos,offline,friends,stories,status,groups"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        let request = URLRequest(url: components.url!)
        return request
    }
}

extension VKLoginController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else { decisionHandler(.allow); return }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let _ = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }
        
        Session.shared.token = token
        performSegue(withIdentifier: "Run the App", sender: nil)
  
        decisionHandler(.cancel)
    }
}

extension VKLoginController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
}
