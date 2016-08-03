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
        gatherHTML()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gatherHTML() -> Void {
        Alamofire.request(.GET, "http://nycmetalscene.com").responseString { response in
            print("Success: \(response.result.isSuccess)")
            self.html = response.result.value
            self.parseHTML()
            
        }
    }
    
    func parseHTML() -> Void {
        if let html = self.html {
            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
                // Search for nodes by CSS
                for show in doc.css("td[id^='Text']") {
                    // Strip the string of surrounding whitespace.
                    let showString = show.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if showString.characters.count > 3 {
                        let showStringIndex = showString.characters.startIndex.advancedBy(3)
                        let showSubString = showString.substringToIndex(showStringIndex).lowercaseString
                        // All text involving shows on this page currently start with the weekday.
                        // Weekday formatting is inconsistent, but the first three letters are always there.
                        if ["mon", "tue", "wed", "thu", "fri", "sat", "sun"].contains(showSubString) {
                            shows.append(showString)
                            print(showString + "\n")
                        }
                    }
                }
                
                print(shows.count)
                
            }
        }
    }

}

