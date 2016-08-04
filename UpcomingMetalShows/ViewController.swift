//
//  ViewController.swift
//  UpcomingMetalShows
//
//  Created by Sam Agnew on 7/25/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import UIKit
import Kanna
import Alamofire


class ViewController: UIViewController {
    
    var html: String?
    var shows: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        gatherMetalShows()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gatherMetalShows() -> Void {
        Alamofire.request(.GET, "http://nycmetalscene.com").responseString { response in
            print("Success: \(response.result.isSuccess)")
            self.html = response.result.value
            self.parseHTML(response.result.value!)
            
        }
    }
    
    func parseHTML(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            
            // Search for nodes by CSS
            for show in doc.css("td[id^='Text']") {
                
                // Strip the string of surrounding whitespace.
                let showString = show.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                if showString.characters.count > 2 {
                    // All text involving shows on this page currently start with the weekday.
                    // Weekday formatting is inconsistent, but the first three letters are always there.
                    let regex = try! NSRegularExpression(pattern: "^(mon|tue|wed|thu|fri|sat|sun)", options: [.CaseInsensitive])
                    
                    if regex.firstMatchInString(showString, options: [], range: NSMakeRange(0, showString.characters.count)) != nil {
                        shows.append(showString)
                        print(showString + "\n")
                    }
                }
            }
            
            print(shows.count)
            
        }
    }

}

