//
//  ViewControllerGoogle.swift
//  iosapp
//
//  Created by alexander on 25.04.2022.
//

import UIKit
import WebKit
import Alamofire

/// The controller for handling webviews.
class AuthWebViewController: UIViewController {
    
    // MARK: Properties
    private var startUrl: String = ""
    private var modifiedRequestUrl: String = ""
    private var delegate: AuthWebViewDelegate?
    
    // MARK: screen elements
    private lazy var webView: WKWebView = {
        let conf = WKWebViewConfiguration()
        conf.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        
        let webView = WKWebView(frame: .zero, configuration: conf)
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeIcon = #imageLiteral(resourceName: "close_icon")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.tintColor = .black
        return UIBarButtonItem(customView: closeButton)
    }()
    
    func setUp(delegate: AuthWebViewDelegate, startUrl: String, modifiedRequestUrl: String) {
        self.startUrl = startUrl
        self.modifiedRequestUrl = modifiedRequestUrl
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = closeButton
        view.addSubview(self.webView)

        webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        webView.load(URLRequest(url: URL(string: startUrl)!))
    }
    
    @objc
    private func close(_ sender: Any) {
        self.dismiss(animated: true)
        (self.navigationController as? AuthNavigationViewController)?.myDelegate?.didCompleteAuth(isSuccessAuth: false)
    }
}

extension AuthWebViewController: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void
    ) {
        let request = navigationAction.request
        let url = request.url!
        
        // Перехватываем нужный url
        if url.absoluteString.contains(modifiedRequestUrl) {
            
            // насыщаем его нужными хедерами
            var headers = HTTPHeaders()
            headers["oauth_fingerprint"] = UIDevice.current.identifierForVendor!.uuidString
            headers["Content-Type"] = "application/json"
            headers["Accept"] = "application/json"
            
            // Копируем куки запроса, забираем сам запрос и закрываем форму
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookie in
                AF.sessionConfiguration.httpCookieStorage?.setCookies(cookie, for: url, mainDocumentURL: nil)
                self.dismiss(animated: true)
                self.delegate?.didFinish(url: url)
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

protocol AuthWebViewDelegate: AnyObject {
    func didFinish(url: URL)
}
