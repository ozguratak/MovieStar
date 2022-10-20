//
//  WebpageViewerViewController.swift
//  MovieStar
//
//  Created by obss on 8.06.2022.
//
//MARK: - WebSayfası kontrolörü; WKWebKit kullanılarak uygulama içerisinde ilgili içeriğin kendine ait web sitesini açar ve sayfa varsa kullanıcıya gösterir. Web sayfası bulunamazsa kullanıcıya pop-up ile hata mesajı verir. 
import UIKit
import WebKit

class WebpageViewerViewController: UIViewController, WKNavigationDelegate {
    private let error = ErrorController.self
    var link: URL?
    private var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sendingUrl = link {
            webView.load(URLRequest(url: sendingUrl))
            webView.allowsBackForwardNavigationGestures = true
        } else { // link patlaksa ekranda hata göster sonra detay sayfasına geri dön
            error.alert(alertInfo: StringKey.homepage, page: self)
        }
    }    
}


