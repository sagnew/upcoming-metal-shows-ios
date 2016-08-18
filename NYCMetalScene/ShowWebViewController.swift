//
//  ShowWebViewController.swift
//  UpcomingMetalShows
//
//  Created by Sam Agnew on 8/10/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import UIKit

class ShowWebViewController: UIViewController {
    var url: String?
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: self.url!)
        webView.loadRequest(NSURLRequest(URL: url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
